import 'package:logger/logger.dart';

final _auditLog = Logger(printer: PrettyPrinter(methodCount: 0));

/// Audit log entry for registry modifications
class AuditLog {
  final String userId;
  final AuditAction action;
  final String resourceType;
  final String resourceId;
  final String? ipAddress;
  final Map<String, dynamic>? details;

  const AuditLog({
    required this.userId,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    this.ipAddress,
    this.details,
  });
}

enum AuditAction { create, update, delete, view }

/// Simple audit logging service for registry modifications
class AuditService {
  /// Log an audit entry
  void log(AuditLog entry) {
    final timestamp = DateTime.now().toIso8601String();
    final actionStr = entry.action.name.toUpperCase();
    final message = '[AUDIT] $timestamp - User: ${entry.userId} | Action: $actionStr | Resource: ${entry.resourceType}:${entry.resourceId}';
    _auditLog.log(Level.info, message);
    if (entry.details != null) {
      _auditLog.log(Level.info, '[AUDIT] Details: ${entry.details}');
    }
  }

  /// Log a create action
  void logCreate({
    required String userId,
    required String resourceType,
    required String resourceId,
    Map<String, dynamic>? details,
  }) {
    log(AuditLog(
      userId: userId,
      action: AuditAction.create,
      resourceType: resourceType,
      resourceId: resourceId,
      details: details,
    ));
  }

  /// Log an update action
  void logUpdate({
    required String userId,
    required String resourceType,
    required String resourceId,
    Map<String, dynamic>? details,
  }) {
    log(AuditLog(
      userId: userId,
      action: AuditAction.update,
      resourceType: resourceType,
      resourceId: resourceId,
      details: details,
    ));
  }

  /// Log a delete action
  void logDelete({
    required String userId,
    required String resourceType,
    required String resourceId,
    Map<String, dynamic>? details,
  }) {
    log(AuditLog(
      userId: userId,
      action: AuditAction.delete,
      resourceType: resourceType,
      resourceId: resourceId,
      details: details,
    ));
  }
}