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
    habitante(Habitante, Raza, AnioNacimiento, _),
    AnioNacimiento =< AnioActual,
    noMurio(Raza, AnioNacimiento, AnioActual).
    
noMurio(elfo, _, _).
    
noMurio(Raza, AnioNacimiento, AnioActual) :-
vidaPromedio(Raza, Vida),
AnioActual =< AnioNacimiento + Vida.

% Punto 2 (Fran)
% conoce(Persona, Hazania, AnioEnQueLaConocio, Forma)
conoce(wirbel,  hazania(rescatarHermanaWirbel, klares), 1390, presenciada).
conoce(frieren, hazania(rescatarHermanaWirbel, klares), 1390, presenciada).
conoce(kanne,   hazania(recuperarGatoPerdido, weise),   1375, presenciada).
conoce(lawine,  hazania(destruirDemonioAura, weise),    1393, cancion).
conoce(voll,    hazania(destruirDemonioAura, auberst),  1400, libro(50)).
conoce(serie,   hazania(destruirReyDemonio, ende),      1335, libro(100)).

% participo(Heroe, Hazania)
participo(strak,   hazania(rescatarHermanaWirbel, klares)).
participo(fern,    hazania(rescatarHermanaWirbel, klares)).
participo(himmel,  hazania(recuperarGatoPerdido, weise)).
participo(frieren, hazania(recuperarGatoPerdido, weise)).
participo(frieren, hazania(destruirDemonioAura, weise)).
participo(denek,   hazania(destruirDemonioAura, auberst)).
participo(frieren, hazania(destruirReyDemonio, ende)).
participo(himmel,  hazania(destruirReyDemonio, ende)).
participo(heiter,  hazania(destruirReyDemonio, ende)).
participo(eisen,   hazania(destruirReyDemonio, ende)).
participo(elHeroeDelSur, hazania(destruirSchlatOmnisciente, ende)).

duracionDelRecuerdo(cancion, 15).
duracionDelRecuerdo(libro(Paginas), Paginas).

recuerdaHazaniaPor(Persona, Hazania, AnioActual, Forma) :-
    conoce(Persona, hazania(Hazania, _), AnioQueLaConocio, Forma),
    AnioQueLaConocio =< AnioActual,
    estaVivo(Persona, AnioActual),
    not(seLeOlvido(Forma, AnioQueLaConocio, AnioActual)).

seLeOlvido(Forma, AnioQueLaConocio, AnioActual) :-
    duracionDelRecuerdo(Forma, Duracion),
    AnioActual > AnioQueLaConocio + Duracion.

recuerdaHazania(Persona, Hazania, AnioActual) :-
    recuerdaHazaniaPor(Persona, Hazania, AnioActual, _).

% b) Una hazania esta corroborada?
seConoceHazania(Hazania, Lugar) :-
    conoce(_, hazania(Hazania, Lugar), _, _).

hazaniaCorroborada(Hazania) :-
    seConoceHazania(Hazania, Lugar),
    forall(
        seConoceHazania(Hazania, OtroLugar),
        OtroLugar = Lugar
    ).
% c) Una hazania paso al olvido?
pasoAlOlvido(Hazania, AnioActual) :-
    seConoceHazania(Hazania, _),
    not(recuerdaHazania(_, Hazania, AnioActual)).


% Punto 3 (Andrea)
% conmemora(Pueblo, Hazania, Forma, AnioEnQueEmpezo)
conmemora(weise,   hazania(destruirReyDemonio, ende),        diaFestivo,           1340).
conmemora(auberst, hazania(destruirReyDemonio, ende),        estatua(equipoHeroes), 1370).
conmemora(auberst, hazania(destruirSchlatOmnisciente, ende), estatua(heroeDelSur),  1340).

materialDeEstatua(equipoHeroes, bronce).
materialDeEstatua(heroeDelSur, marmol).

% mantenimiento(Estatua, Anio)
mantenimiento(equipoHeroes, 1400).
mantenimiento(equipoHeroes, 1450).
mantenimiento(heroeDelSur, 1410).

duracionMaterial(marmol, 30).
duracionMaterial(bronce, 15).

conoce(Persona, Hazania, AnioQueLaConocio, Forma) :-
    habitante(Persona, _, AnioNacimiento, Pueblo),
    conmemora(Pueblo, Hazania, Forma, AnioEnQueEmpezo),
    AnioQueLaConocio is max(AnioNacimiento, AnioEnQueEmpezo).

seLeOlvido(estatua(Estatua), _, AnioActual) :-
    not(estatuaEnBuenEstado(Estatua, AnioActual)).

tuvoUnCuidado(Estatua, Anio) :- mantenimiento(Estatua, Anio).
tuvoUnCuidado(Estatua, Anio) :- conmemora(_, _, estatua(Estatua), Anio).

estatuaEnBuenEstado(Estatua, AnioActual) :-
    tuvoUnCuidado(Estatua, AnioDelCuidado),
    AnioDelCuidado =< AnioActual,
    materialDeEstatua(Estatua, Material),
    duracionMaterial(Material, Duracion),
    AnioActual =< AnioDelCuidado + Duracion.

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
test("Serie está viva en el año 5000 porque los elfos no mueren de viejos.", nondet):-
    estaVivo(serie, 5000).

% Tests Punto 2
test("Lawine no recuerda destruir al demonio Aura en 1380 porque aun no escucho una cancion sobre esa hazana."):-
    \+ recuerdaHazania(lawine, destruirDemonioAura, 1380).
test("Lawine recuerda destruir al demonio Aura en 1400", nondet):-
    recuerdaHazania(lawine, destruirDemonioAura, 1400).
test("Lawine ya no recuerda destruir al demonio Aura en 1410, porque pasaron mas de 15 anios de que escucho la cancion"):-
    \+ recuerdaHazania(lawine, destruirDemonioAura, 1410).
test("Voll recuerda destruir al demonio Aura en 1450", nondet):-
    recuerdaHazania(voll, destruirDemonioAura, 1450).
test("Voll no recuerda destruir al demonio Aura en 1460"):-
    \+ recuerdaHazania(voll, destruirDemonioAura, 1460).
test("Wirbel recuerda rescatar a la hermana de wirbel en 1430", nondet):-
    recuerdaHazania(wirbel, rescatarHermanaWirbel, 1430).
test("Wirbel ya no recuerda rescatar a la hermana de wirbel en 1440 porque no esta vivo en ese anio"):-
    \+ recuerdaHazania(wirbel, rescatarHermanaWirbel, 1440).
test("rescatar a la hermana de Wirbel es una hazana corroborada", nondet):-
    hazaniaCorroborada(rescatarHermanaWirbel).
test("destruir al demonio Aura no es una hazana corroborada (las diferentes personas que la conocen no estan de acuerdo ni en lugar ni en los heroes que la llevaron a cabo)"):-
    \+ hazaniaCorroborada(destruirDemonioAura).
test("destruir al demonio Aura paso al olvido en 1460", nondet):-
    pasoAlOlvido(destruirDemonioAura, 1460).
test("destruir al demonio Aura no paso al olvido en 1440"):-
    \+ pasoAlOlvido(destruirDemonioAura, 1440).

% Tests Punto 3 (Andrea)

test("Lawine recuerda destruir al rey demonio en 1400", nondet):-
    recuerdaHazania(lawine, destruirReyDemonio, 1400).

test("Lawine no recuerda destruir al rey demonio en 1390"):-
    \+ recuerdaHazania(lawine, destruirReyDemonio, 1390).

test("Fern recuerda destruir al rey demonio en 1400", nondet):-
    recuerdaHazania(fern, destruirReyDemonio, 1400).
:- end_tests(tpIntegrador).