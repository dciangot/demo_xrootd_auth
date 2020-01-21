# HandOn su "data access"

La demo e' effettuata usando come macchina client la UI `lxplus.cern.ch` (client-vm) e come storage remoto una macchina della cloud @Bar (remote-vm).

## XRootD

### Demo 1
#### Accesso RW a livello di gruppo utenti (VO-like)

Sulla `remote-vm` facciamo partire il processo xrootd e controlliamo i log

```bash
service xrootd@X509vo start
cat /var/log/xrootd/X509vo/xrootd.log
```

Sulla `client-vm` proviamo a copiare un file 

```bash
voms-proxy-init --voms cms
xrdcp data/test.txt root://90.147.174.89//cms/test.txt
xrdcp data/test.txt root://90.147.174.89//atlas/test.txt
```

Sulla `remote-vm` verifichiamo che i file siano a destinazione e copiamo un file nel namespace atlas per provare poi a leggerlo da remoto

```bash
ls -l /data/x509/
# Con il comando precedente abbiamo controllato che entrambe
# le cartelle appartengono allo user xrootd
ls /data/x509/cms/
ls /data/x509/atlas/
cp data/test.txt /data/x509/atlas
chown -R xrootd: /data/x509/atlas
```

Sulla `client-vm` proviamo a leggere i file appena inseriti

```bash
xrdcp root://90.147.174.89//cms/test.txt test_cms.txt
xrdcp root://90.147.174.89//atlas/test.txt test_atlas.txt
```

#### Passare da Token IAM a X509 proxy

Tutto questo visto con proxy grid, puo' essere riadattato in uno scenario piu generico.
Infatti un token IAM puo' essere "tradotto" in una identita' X509 da un servizio chiamato TokenTranslationService.

### Demo 2
#### Accesso RW a livello di singoli utenti

Sulla `remote-vm` facciamo partire il processo xrootd e controlliamo i log

```bash
service xrootd@X509vo stop
service xrootd@X509map start
cat /var/log/xrootd/X509map/xrootd.log
```

Sulla `client-vm` proviamo a copiare un file

```bash
voms-proxy-init --voms cms
xrdcp data/test.txt root://90.147.174.89//tizio/test.txt
xrdcp data/test.txt root://90.147.174.89//caio/test.txt
```

Sulla `remote-vm` verifichiamo che i file siano a destinazione e copiamo un file nel namespace atlas per provare poi a leggerlo da remoto

```bash
ls -l /data/user/
# Con il comando precedente abbiamo controllato che le 2 cartelle
# appartengono a 2 user distinti
ls /data/user/tizio/
ls /data/user/caio/
cp data/test.txt /data/user/caio
chown -R caio: /data/user/caio
```

Sulla `client-vm` proviamo a leggere i file appena inseriti

```bash
xrdcp root://90.147.174.89//tizio/test.txt test_tizio.txt
xrdcp root://90.147.174.89//caio/test.txt test_caio.txt
```


## HTTP

### Demo 3
#### Accesso RW a livello di gruppo utenti (VO-like)

