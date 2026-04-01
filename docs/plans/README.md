# Plans

Forge ticket lifecycle. Each ticket is a folder named `FRG-XXXX-short-description/`
containing two files: `brief.md` (human-written) and `contract.md` (Compile-generated).

## Structure

```
FRG-XXXX-short-description/
  brief.md      ← human writes this to start the pipeline
  contract.md   ← Compile generates this from the brief
```

## Folders

| Folder | Status | Description |
|---|---|---|
| `_template/` | — | Templates for brief.md and contract.md |
| `active/` | In progress | Tickets currently being worked on |
| `shipped/` | Merged | Tickets whose PR has been merged to main |
| `archived/` | Closed | Tickets that were cancelled, rejected, or abandoned |

## Lifecycle

```
active/FRG-XXXX/   →   shipped/FRG-XXXX/   (PR merged)
active/FRG-XXXX/   →   archived/FRG-XXXX/  (cancelled or abandoned)
```
