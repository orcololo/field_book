import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/repositories/session_repository.dart';
import '../../../models/collection_session.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';

const _uuid = Uuid();

class SessionFormScreen extends ConsumerStatefulWidget {
  final CollectionSession? session; // null for new session

  const SessionFormScreen({
    super.key,
    this.session,
  });

  @override
  ConsumerState<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends ConsumerState<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tripNameController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late DateTime _startDate;
  DateTime? _endDate;
  final List<String> _teamMembers = [];
  final TextEditingController _memberController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tripNameController = TextEditingController(text: widget.session?.tripName ?? '');
    _locationController = TextEditingController(text: widget.session?.location ?? '');
    _notesController = TextEditingController(text: widget.session?.notes ?? '');
    _startDate = widget.session?.startDate ?? DateTime.now();
    _endDate = widget.session?.endDate;
    if (widget.session != null) {
      _teamMembers.addAll(widget.session!.teamMembers);
    }
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _memberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If end date is before start date, clear it
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addTeamMember() {
    final member = _memberController.text.trim();
    if (member.isNotEmpty && !_teamMembers.contains(member)) {
      setState(() {
        _teamMembers.add(member);
        _memberController.clear();
      });
    }
  }

  void _removeTeamMember(String member) {
    setState(() {
      _teamMembers.remove(member);
    });
  }

  Future<void> _saveSession() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      
      final session = widget.session ?? CollectionSession();
      
      if (widget.session == null) {
        // New session
        session.uuid = _uuid.v4();
        session.createdAt = DateTime.now();
      }
      
      session.tripName = _tripNameController.text.trim();
      session.location = _locationController.text.trim().isEmpty 
          ? null 
          : _locationController.text.trim();
      session.notes = _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim();
      session.startDate = _startDate;
      session.endDate = _endDate;
      session.teamMembers = List.from(_teamMembers);

      await sessionRepo.save(session);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorSavingSession(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.session != null;

    return Scaffold(
      appBar: ModernAppBar(
        title: isEditing ? l10n.editSessionTitle : l10n.newSession,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Trip Name
            TextFormField(
              controller: _tripNameController,
                decoration: InputDecoration(
                  labelText: l10n.sessionTripNameLabel,
                  hintText: l10n.sessionTripNameHint,
                  prefixIcon: const Icon(Icons.folder),
                  border: const OutlineInputBorder(),
                ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.sessionTripNameRequired;
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l10n.location,
                hintText: l10n.sessionLocationHint,
                prefixIcon: const Icon(Icons.location_on),
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Start Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(l10n.startDate),
                subtitle: Text(
                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.edit),
                onTap: () => _selectDate(context, true),
              ),
            ),
            const SizedBox(height: 8),

            // End Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text(l10n.endDate),
                subtitle: Text(
                  _endDate != null
                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : l10n.notSpecified,
                  style: TextStyle(
                    fontWeight: _endDate != null ? FontWeight.bold : null,
                    color: _endDate == null ? Colors.grey : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_endDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _endDate = null;
                          });
                        },
                      ),
                    const Icon(Icons.edit),
                  ],
                ),
                onTap: () => _selectDate(context, false),
              ),
            ),
            const SizedBox(height: 16),

            // Team Members Section
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.teamLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Add team member
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _memberController,
                  decoration: InputDecoration(
                    hintText: l10n.teamMemberNameHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) => _addTeamMember(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addTeamMember,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Team members list
            if (_teamMembers.isNotEmpty)
              Card(
                child: Column(
                  children: _teamMembers.map((member) {
                    return ListTile(
                      dense: true,
                      leading: const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 16),
                      ),
                      title: Text(member, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () => _removeTeamMember(member),
                      ),
                    );
                  }).toList(),
                ),
              ),
            
            if (_teamMembers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.noTeamMembersAdded,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Notes
            const Divider(),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.notes,
                hintText: l10n.sessionNotesHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Save Button
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveSession,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? l10n.saving : l10n.saveSessionLabel),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
