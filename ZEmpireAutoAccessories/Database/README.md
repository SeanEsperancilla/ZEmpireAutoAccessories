# Sharing the data with the team

Git carries the **code**. It does not carry the SQL Server database — that
lives on each machine. So pulling `Programmer` gives a teammate the app, and
then an empty or stale `ZEmpire` database behind it.

Three things have to travel together for everyone to see the same system:

| What | How it travels | Where |
| --- | --- | --- |
| The database | A SQL Server backup, committed | `Database/ZEmpireUpdated.bak` |
| Cut sizes | A JSON file, committed | `App_Data/cut-sizes.json` |
| Settings | Committed already | `appsettings.json` |

They must be refreshed **together**. Cut sizes are keyed by
`VehicleClassificationID` and `PanelID` — the database's own ids — so a
cut-size file from one database points at the wrong panels in another.

---

## Publishing your data (the person with the real system)

**1. Back up the database over the committed file.**

In SSMS, against your `ZEmpire` database:

```sql
BACKUP DATABASE ZEmpire
TO DISK = N'C:\path\to\ZEmpireAutoAccessories\ZEmpireAutoAccessories\Database\ZEmpireUpdated.bak'
WITH FORMAT, INIT, COMPRESSION, NAME = N'ZEmpire full backup';
```

`FORMAT, INIT` overwrite the file rather than appending, so it stays one
backup and does not grow with every share.

**2. Commit the backup and the cut sizes.**

```
git add ZEmpireAutoAccessories/Database/ZEmpireUpdated.bak
git add ZEmpireAutoAccessories/App_Data/cut-sizes.json
git commit -m "Refresh the shared database snapshot"
git push -u origin Programmer
```

**3. Tell the team to restore.** A pull alone does not change their database.

---

## Loading it (everyone else)

**1. Pull.**

```
git checkout Programmer
git pull origin Programmer
```

**2. Restore the backup.** The logical names inside it are `ZEmpire` and
`ZEmpire_log`; the paths are whatever your SQL Server uses, which is why
`WITH MOVE` is needed:

```sql
RESTORE FILELISTONLY
FROM DISK = N'C:\path\to\...\Database\ZEmpireUpdated.bak';
```

```sql
RESTORE DATABASE ZEmpire
FROM DISK = N'C:\path\to\...\Database\ZEmpireUpdated.bak'
WITH MOVE N'ZEmpire'     TO N'C:\Program Files\Microsoft SQL Server\<your instance>\MSSQL\DATA\ZEmpire.mdf',
     MOVE N'ZEmpire_log' TO N'C:\Program Files\Microsoft SQL Server\<your instance>\MSSQL\DATA\ZEmpire_log.ldf',
     REPLACE, RECOVERY;
```

Close any open connection to `ZEmpire` first or the restore is blocked.

**3. Check the connection string.** `appsettings.json` uses `Server=.;`, the
default instance. On SQL Express it is `Server=.\SQLEXPRESS;`. Change it
locally and **do not commit that change**, or it will keep flipping for
everybody:

```
git update-index --skip-worktree ZEmpireAutoAccessories/appsettings.json
```

**4. Run the app.** Startup adds any missing payment mode and the Identity
roles; it changes nothing that is already there.

---

## What does not travel, and why

**Proof of payment and warranty claim files** (`App_Data/payment-proofs/`)
are customers' bank receipts, with names, reference numbers and account
details on them. They stay out of the repository. A teammate's rows will
show as missing their proof, which is correct — they do not have the file.

**Stock postings** (`App_Data/stock-postings.json`) is what each completed
document took off the shelf, and it changes every time one is completed.
Tracking it would mean a merge conflict on nearly every commit. Without it,
reverting a document completed on someone else's machine falls back to
recomputing from the cut sizes, which is what the app did before the file
existed.

---

## A warning about repository size

The backup is ~16 MB and git keeps **every** version forever. Ten refreshes
is 160 MB that never goes away, even after deleting the file. If this is
going to be a regular thing, either:

- keep the backup out of git and share it on a drive or chat, or
- put it behind [Git LFS](https://git-lfs.com) before the next refresh.

The seed scripts beside this file (`SeedPricelist2026.sql` and the rest) are
the alternative: text, diffable, and they rebuild the catalogue from nothing.
They do not carry transactions — sales, invoices, job orders — which is what
the backup is for.
