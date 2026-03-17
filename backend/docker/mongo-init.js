db = db.getSiblingDB('fieldbook');

db.createCollection('users');
db.createCollection('species');
db.createCollection('registries');
db.createCollection('collectionsessions');

db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ googleId: 1 }, { unique: true, sparse: true });

db.species.createIndex({ scientificNameLower: 1 }, { unique: true });
db.species.createIndex(
  { scientificName: 'text', commonName: 'text', family: 'text' },
  { weights: { scientificName: 3, commonName: 2, family: 1 } },
);

db.registries.createIndex({ uuid: 1 }, { unique: true });
db.registries.createIndex({ registryIdentifier: 1 }, { unique: true });
db.registries.createIndex({ collector: 1, sessionId: 1 });
db.registries.createIndex({ species: 1 });
db.registries.createIndex({ collector: 1 });
db.registries.createIndex({ 'syncMetadata.syncStatus': 1 });
db.registries.createIndex({ updatedAt: 1 });

db.collectionsessions.createIndex({ uuid: 1 }, { unique: true });
db.collectionsessions.createIndex({ shareCode: 1 }, { unique: true, sparse: true });
db.collectionsessions.createIndex({ owner: 1, isArchived: 1 });
db.collectionsessions.createIndex({ 'syncMetadata.syncStatus': 1 });
db.collectionsessions.createIndex({ updatedAt: 1 });
db.collectionsessions.createIndex(
  { tripName: 'text', location: 'text' },
  { weights: { tripName: 2, location: 1 } },
);
