# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup
This is a discussion of a proposed distributed architecture for the LaunchPad LMS MongoDB event records. The practical work currently uses a single local MongoDB server (version 8.0.4) running alongside PostgreSQL inside one Ubuntu GitHub Codespace. No MongoDB replica set, sharding architecture, or failover testing is implemented in this example. Being hosted in a Codespace does not mean the database has multiple copies on separate servers.

## Proposed replication
Replication creates and maintains identical copies of data across different database servers to ensure availability. A proposed MongoDB replica set for the LMS would consist of three voting, data-holding members:

| Member | Starting role | Location |
| :--- | :--- | :--- |
| A | Primary: accepts event writes | Host 1 |
| B | Secondary: copies event changes | Host 2 |
| C | Secondary: copies event changes | Host 3 |

These hosts would be placed in separate physical failure zones so that one host or zone failure does not take the entire system offline. When an enrollment event (such as Ada James enrolling in React Basics) is written to the primary, the secondaries copy it asynchronously. Because of this, a secondary might briefly hold slightly older event data. 
[MongoDB Replication](https://www.mongodb.com/docs/manual/replication/)

## Failure and consistency
If Member A fails, the two remaining members can elect an eligible secondary as the new primary, provided they can communicate and form a voting majority. New writes are temporarily paused during this election, meaning failover is neither instant nor guaranteed if the required members are missing. If only one voting member remains reachable, there is no majority to elect a writable primary, and the system becomes read-only.
[Replica Set Elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)

For critical LMS events, this proposed design requests majority write acknowledgement: at least two of the three members must acknowledge the write before it is considered successful. This prevents the loss of an acknowledged event if the primary suddenly fails, though it requires a reachable majority and adds slight waiting time. Recent-event queries should be directed to the primary, as secondary reports may lag. Crucially, current course availability and strict enrollment rules still rely on PostgreSQL and its transaction controls, not a potentially delayed MongoDB event copy.
[Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/)

## Sharding and cloud deployment
Sharding splits records across groups of servers, whereas replication copies the same records. Four fictional example events do not justify sharding. If event volume grows enough to exceed one replica set's capacity, shard-key selection would require evidence about LaunchPad's query patterns. No sharding is implemented here.
[Sharding](https://www.mongodb.com/docs/manual/sharding/)

A cloud deployment could use a managed MongoDB service, providing database authentication, encrypted connections, restricted network access, and scheduled backups that are regularly tested via restoration. The available features and costs must be evaluated for the chosen deployment. Replication does not replace backups: an accidental deletion of an event will instantly replicate and delete the copies too. Furthermore, MongoDB replication does not protect the whole LMS; PostgreSQL needs its own distinct availability and recovery plan, as the two databases are not automatically synchronised.
[Atlas Backup Options](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)