```
{:ok, db} = :rocksdb.open(~c"/tmp/nicola", [create_if_missing: true])
{:ok, db, _} = :rocksdb.open_optimistic_transaction_db(~c"/tmp/nicola", [create_if_missing: true])
{:ok, tr} = :rocksdb.transaction(db, [])

:rocksdb.transaction_get(tr, "global_position", [])
{:ok, pos} = :rocksdb.transaction_get(tr, "global_position", [])

{:ok, tr} = :rocksdb.transaction_put(tr, "global_position", pos + 1)

:ok = :rocksdb.transaction_commit(tr)

```
```
iex(1)> e = Event.new "abcdd", "event_occurred", %{test: 6}
iex(5)> BeamFlow.add_event e
iex(6)> Writer.show_database
```

