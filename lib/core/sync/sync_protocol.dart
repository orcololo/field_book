/// Sync protocol constants — kept in sync with the backend's
/// `backend/src/modules/sync/sync.constants.ts`.
///
/// Sent on every sync push/pull so the server can:
///   * Reject clients running an incompatible protocol with a clear error
///     (better than silent data corruption from schema drift).
///   * Route requests to legacy handlers during rolling upgrades.
///
/// The client is responsible for bumping [kCurrentSyncProtocolVersion] when
/// it adds new sync fields, payload formats (e.g., JSON Patch), or contract
/// changes that the server must opt into.
library;

const String kSyncProtocolVersionHeader = 'X-Sync-Protocol-Version';

/// Current wire-format version. Use semver-major.minor; bumping major signals
/// a breaking change.
const String kCurrentSyncProtocolVersion = '1.0';
