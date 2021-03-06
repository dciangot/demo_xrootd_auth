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
service xrootd-privileged@X509map start
cat /var/log/xrootd/X509map/xrootd.log
```

Sulla `client-vm` proviamo a copiare un file

```bash
voms-proxy-init --voms cms
xrdcp data/test.txt root://90.147.174.89//tizio/test.txt
xrdcp data/test.txt root://90.147.174.89//caio/test.txt
```

Sulla `remote-vm` verifichiamo che i file siano a destinazione e copiamo un file nel namespace caio per provare poi a leggerlo da remoto

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

Sulla `remote-vm` facciamo partire il processo xrootd e controlliamo i log

```bash
service xrootd@X509map stop
service xrootd-privileged@tokens start
cat /var/log/xrootd/tokens/xrootd.log
```

Sulla `client-vm` proviamo a copiare un file

```bash
# Retrieve the token with
source scripts/get_token.sh
export TOKEN=...
export HEADER="Authorization: Bearer ${TOKEN}"
# get the files with 
curl  -k -XPUT -H "$HEADER" https://90.147.174.89:8443//votest/test.txt --data-urlencode @data/test.txt
curl  -k -XPUT -H "$HEADER" https://90.147.174.89:8443//votest2/test.txt --data-urlencode @data/test.txt
```

Sulla `remote-vm` verifichiamo che i file siano a destinazione e copiamo un file nel namespace atlas per provare poi a leggerlo da remoto

```bash
ls -l /data/http/
# Con il comando precedente abbiamo controllato che le 2 cartelle
# appartengono a 2 user distinti
ls /data/http/votest/
ls /data/http/votest2/
cp data/test.txt /data/http/votest2/
chown -R votest2: /data/http/votest2/
# Limit read to votest2 only
chmod -R 700 /data/http/votest2/
```

Sulla `client-vm` proviamo a leggere i file appena inseriti

```bash
curl  -k -XGET -H "$HEADER" https://90.147.174.89:8443//votest/test.txt
curl  -k -XGET -H "$HEADER" https://90.147.174.89:8443//votest2/test.txt
```
