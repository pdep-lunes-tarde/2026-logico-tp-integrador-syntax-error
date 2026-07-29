% Punto 1 (Cristian)
% a)
habitante(denek, humano, 1290, auberst).
habitante(voll, enano, 1200, ende).
habitante(serie, elfo, 500, weise).
habitante(fern, humano, 1370, weise).
habitante(strak, humano, 1368, riegel).
habitante(lawine, humano, 1372, auberst).
habitante(kanne, humano, 1365, weise).
habitante(wirbel, humano, 1350, klares).
habitante(lernen, humano, 1315, auberst).
habitante(frieren, elfo, 100, weise).
habitante(eisen, enano, 1150, riegel).

% b)
vidaPromedio(humano, 80).
vidaPromedio(enano, 350).

estaVivo(Habitante, AnioActual) :-
    habitante(Habitante, humano, AnioNacimiento, _),
    AnioNacimiento =< AnioActual,
    AnioActual =< AnioNacimiento + 80.

estaVivo(Habitante, AnioActual) :-
    habitante(Habitante, enano, AnioNacimiento, _),
    AnioNacimiento =< AnioActual,
    AnioActual =< AnioNacimiento + 350.

estaVivo(Habitante, AnioActual) :-
    habitante(Habitante, elfo, AnioNacimiento, _),
    AnioNacimiento =< AnioActual.

% Punto 2 ()
% a)


% b)


% c)


% Punto 3 ()
% a)


% b)


:- begin_tests(tpIntegrador, []).
% Tests Punto 1
test("Kanne (humana, nacida en 1365) está viva en 1370.", nondet):-
    estaVivo(kanne, 1370).
test("Kanne no está viva en 1300, porque todavía no había nacido."):-
    \+ estaVivo(kanne, 1300).
test("Kanne no está viva en 2000, porque ya habría muerto."):-
    \+ estaVivo(kanne, 2000).
test("Voll está vivo en 1550 ya que nació en 1200 y por ser enano vive 350 años.", nondet):-
    estaVivo(voll, 1550).
test("Voll ya no está vivo en 1551."):-
    \+ estaVivo(voll, 1551).
test("Serie está viva en el año 5000 porque los elfos no mueren de viejos."):-
    estaVivo(serie, 5000).

% Tests Punto 2


% Tests Punto 3

:- end_tests(tpIntegrador).
