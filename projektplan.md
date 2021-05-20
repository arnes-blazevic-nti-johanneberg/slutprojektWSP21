# Projektplan

## 1. Projektbeskrivning (Beskriv vad sidan ska kunna göra). 
Sidan är tänkt att vara ett samlingsforum för alla som äslkar att läsa, men även för personer som vill hitta sin allra första bok att läsa. På sidan ska man kunna skapa en lista på alla ens böcker som man läst, betygsätta de böckerna och kunna bli rekomenderad böcker som andra läst och rekomenderar. Man ska lätt kunna hitta olika böcker genom att antigen sortera efter betyg eller genrer. Man ska även kunna hitta vänner och följa varandra och se deras samlade bibliotek. Man ska helt enkelt kunna hitta nya böcker att läsa men även hitta nya vänner att kunna diskutera böcker med eller kasnke något helt annat, sidan ska iallafall funktionera som en connection mellan olika personer och binda sammandem med den gemensamma faktorn.... kärleken för böker.
## 2. Vyer (visa bildskisser på dina sidor).
#Index sida(första sidan när man öppnar hemsidan)
![Image description](misc\Skisser\IMG_2193.jpg)
#Sida där man kan logga in sig
![Image description](misc\Skisser\IMG_2194.jpg)
#Sida där man kan registrera sig
![Image description](misc\Skisser\IMG_2195.jpg)
#Sida där man ser alla sina böcker och kan lägga till fler, edita, delete, samt hitta helt nya böcker som andra användare läst och rekomenderar
![Image description](misc\Skisser\IMG_2196.jpg)
#sida där man väljer genre och sedan söker och hittar alla böcker med den valda genren som andra rekomenderar
![Image description](misc\Skisser\IMG_2197.jpg)

#eventuelt hur huvudsidan skulle kunnat se ut om man lägger ner mycket tid på CSS
![Image description](misc\Skisser\IMG_1167.jpg)


## 3. Databas med ER-diagram (Bild på ER-diagram).
![Image description](misc\ER-Diagram\IMG_1234-kopia.jpg)
## 4. Arkitektur (Beskriv filer och mappar - vad gör/innehåller de?).
slim filen index.slim är första sidan när man kommer fram på sidan där man kan välja att logga in eller skapa nytt konto för att sedan ta sig vidare

mappen i views mappen finns users mappen, det är där man kan skapa konto respektive registera sig där båda sakerna sedan lagras i databasen

I views mappen finns även books mappen som innehåller index.slim sidan som egentligen är huvudsidan i min webbplats. Den sidan är där alla ens individuella registrerade böcker listas, där kan man uppdatarea befintliga böcker, radera befintliga böcker eller lägga in ännu fler lästa böcker, Varje bok får en genre som lagras i en tabell tillsammans denes id och namn. Man kan även från denna sidan logga ut eller ta sig vidare till en ny sida där man kan upptäcka nya böcker som andra har läst.

I views mappen finns även books mappen som inehåller mappen findbooks som inehåller index.slim som är en simpel sida där du väljer vilken genre du vill söka om och hitta nya böcker, sidan i sig är välldigt simpel men viktig.

I views mappen finns även books mappen som inehåller mappen findbooks som inehåller show.slim som är en sida där beroende på vad du valt i ovanstående sida kommer få fram olika informationer, du kommer få fram alla böcker som inehåller just den genren som du valt att hitta om. På denna sidan så kommer du att kunna hitta alla böcker med vald genre som finns lagrad av andra användare i vårat system.

