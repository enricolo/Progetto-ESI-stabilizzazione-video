# Progetto-ESI-stabilizzazione-video-UNIVR

RELAZIONE PROGETTO STABILIZZAZIONE VIDEO



Partendo dalla stabilizzazione video vista in laboratorio ho aggiunto la stabilizzazione per quanto riguarda la rotazione

Per prima cosa bisogna inserire il nome e il formato del video nel codice,
Per effettuare la stabilizzazione del video, vengono estrapolati i frame dal video scelto.
Per velocizzare il processo, nel caso in cui il video sia in alta risuluzione, viene scalato.
Per l’elaborazione viene tolto il colore dai frame e selezionando un’area ‘ancora dell’immagine, viene ricavato un template rettangolare,
Questo verrà usato nella cross correlazione per confrontare template e frames

Per trovare la rotazione nel video, il template viene confrontato con un frame che viene ruotato all’interno di un range di valori
Il range dipende da quanto era ruotato il frame precedente, in modo che se il video è affetto da ampie rotazioni il range sarà più ampio rispetto ad un video stabile 
questo processo si ripete per ogni frame del video

Una volta salvati i valori di cross correlazione e l’angolo a cui deve essere ruotato ogni frame, 
viene ricostruito il video, ruotando i frame colorati e aggiungengo loro un padding.
il padding è per uniformare la dimensione dei frame, dato che usando una rotazione ‘loose’ alcuni hanno ora le dimensioni diverse

Successivamente vengono calcolate le coordinate del punto di massima cross correlazione, in modo da traslare, se necessario, il frame in posizione corretta

Questo procedimento permette di stabilizzare la traslazione e la rotazione di video che hanno un punto ‘ancora’

Non funziona nel caso in cui il punto preso come ancora cambi le sue dimensioni o venga nascosto (o nel caso in cui esca dal frame)
