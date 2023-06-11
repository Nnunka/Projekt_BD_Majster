# INSTUKCJA PRZYGOTOWANIA ŚRODOWISKA APLIKACJI MAJSTER

**!!! DOKŁADNIEJSZA INSTRUKCJA, WRAZ ZE SCREENAMI POSTĘPOWANIA KROK PO KROKU ZNAJDUJE SIĘ W REPOZYTORIUM W PLIKU O NAZWIE ***README.pdf*** !!!**
1. Sklonuj repozytorium.
2. Otwórz pgAdmin4.
3. Stwórz nowego użytkownika o nazwie „Majster” z hasłem „Majster”, oraz nadaj mu
odpowiednie uprawnienia.
4. Utwórz nową bazę danych o nazwie "Majster" której właścicielem jest użytkownik o
nazwie "Majster".
5. Odtwórz strukturę bazy za pomocą pliku Majster.sql, który znajduje się w folderze
database.
6. Uruchom terminal w folderze Majster 2.0, a następnie wydaj kolejno polecenia:
`npm install`
`npm run dev`
7. Otwórz przeglądarkę internetową, w pasku wyszukiwania wpisz:
`localhost:5000`

Dane do zalogowania z rożnym poziomem uprawnień użytkownika:<br />
Admin – login: admin, hasło: haslo<br />
Pracownik – login: user, hasło: haslo<br />
Serwisant – login: serwis, hasło: haslo<br />
