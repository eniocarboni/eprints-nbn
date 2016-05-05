EPRINTS NBN
===========

Plugin per [EPrints](http://www.eprints.org) per l'assegnazione automatica di identificatori [urn:nbn](http://www.depositolegale.it/national-bibliography-number/)



Installazione
-------------

Copiare il contenuto della directory __cfg__ in __{ARCHIVE}/cfg/__


Credenziali
-----------
Le credenziali di autenticazione al webservice, ottenute in seguito all'adesione al servizio si trovano nel file di configurazione 

__cfg/cfg.d/nbn.pl__

Nuovi campi del database
------------------------
Gli identificatori urn:nbn saranno salvati in un nuovo campo dell'oggetto EPrint (mappato con una nuova colonna della database)

Per ogni riferimento vedere il file di configurazione __cfg/cfg.d/nbn.pl__

Aggiornamento database
----------------------
Per aggiornare la struttura del database

```
    cd $EPRINT_HOME
    ./bin/epadmin update_database_structure {ARCHIVE} --verbose
```

Visualizzazione di una checkbox per la generazione dell'nbn nel workflow
------------------------------------------------------------------------
Aggiungere la configurazione presente nel file __cfg/workflows/eprints/nbn.xml__ al file di workflow __default.xml__
verrà visualizzata una checkbox ai soli utenti amministratori

Salvataggio dell'nbn
--------------------
al salvataggio dell'EPrints (o dopo un'avanzamento di step nel workflow) verrà chiamato il webservice del registro nbn e in seguito ad una risposta positiva verrà salvato l'identificatore nel database.

Vedere il file di configurazione per maggiori dettagli sul TRIGGER utilizzato 

Visualizzazione dell'nbn nella pagina di dettaglio dell'eprint
--------------------------------------------------------------
Per visualizzare l'nbn basta aggiungere il campo nell'elenco dei campi presenti nel riferimento ad ARRAY $c->{summary_page_metadata} presente nel file di configurazione __{ARCHIVE}/cfg/cfg.d/eprint_render.pl__ 

Licenza
-------

[Public Domain](http://creativecommons.org/publicdomain/zero/1.0/)

