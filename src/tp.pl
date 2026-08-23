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

% Punto 4 Fran
pueblo(auberst).
pueblo(ende).
pueblo(weise).
pueblo(riegel).
pueblo(klares).

habitanteVivoDe(Pueblo, Persona, Anio) :-
    habitante(Persona, _, _, Pueblo),
    estaVivo(Persona, Anio).

% a) En un pueblo se recuerda una hazania?
seRecuerdaEn(Pueblo, Hazania, Anio) :-
    habitante(Persona, _, _, Pueblo),
    recuerdaHazania(Persona, Hazania, Anio).

hazaniasRecordadasEn(Pueblo, Anio, Hazanias) :-
    pueblo(Pueblo),
    findall(Hazania, seRecuerdaEn(Pueblo, Hazania, Anio), ConRepetidos),
    sort(ConRepetidos, Hazanias).

% b) Cuantas paginas se leyeron en un pueblo en un anio?
paginasLeidasPor(Pueblo, Anio, Paginas) :-
    habitante(Persona, _, _, Pueblo),
    conoce(Persona, _, Anio, libro(Paginas)).

paginasLeidasEn(Pueblo, Anio, Total) :-
    pueblo(Pueblo),
    findall(Paginas, paginasLeidasPor(Pueblo, Anio, Paginas), TodasLasPaginas),
    sum_list(TodasLasPaginas, Total).

% c) Cual es el pueblo mas lector?
puebloMasLector(Pueblo, Anio) :-
    paginasLeidasEn(Pueblo, Anio, Total),
    Total > 0,
    forall(
        paginasLeidasEn(_, Anio, OtroTotal),
        Total >= OtroTotal
    ).

% d) Un pueblo es musical?
seRecuerdaPorCancionEn(Pueblo, Hazania, Anio) :-
    habitante(Persona, _, _, Pueblo),
    recuerdaHazaniaPor(Persona, Hazania, Anio, cancion).

puebloMusical(Pueblo, Anio) :-
    hazaniasRecordadasEn(Pueblo, Anio, Hazanias),
    length(Hazanias, Total),
    Total > 0,
    findall(Hazania, seRecuerdaPorCancionEn(Pueblo, Hazania, Anio), ConRepetidas),
    sort(ConRepetidas, PorCancion),
    length(PorCancion, CantidadMusicales),
    CantidadMusicales * 2 > Total.

% e) Un pueblo es chismoso?
puebloChismoso(Pueblo, Anio) :-
    pueblo(Pueblo),
    seRecuerdaEn(Pueblo, _, Anio),
    forall(
        seRecuerdaEn(Pueblo, Hazania, Anio),
        not(hazaniaCorroborada(Hazania))
    ).

% f) Una hazania es importante para un pueblo?
hazaniaImportantePara(Pueblo, Hazania, Anio) :-
    seRecuerdaEn(Pueblo, Hazania, Anio),
    forall(
        habitanteVivoDe(Pueblo, Persona, Anio),
        recuerdaHazania(Persona, Hazania, Anio)
    ).

% g) Un pueblo vive tiempos sin precedentes?
fuePresenciadaEn(Pueblo, Hazania, Anio) :-
    habitante(Persona, _, _, Pueblo),
    recuerdaHazaniaPor(Persona, Hazania, Anio, presenciada).

viveTiemposSinPrecedentes(Pueblo, Anio) :-
    pueblo(Pueblo),
    hazaniaImportantePara(Pueblo, _, Anio),
    forall(
        hazaniaImportantePara(Pueblo, Hazania, Anio),
        fuePresenciadaEn(Pueblo, Hazania, Anio)
    ).

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

% Tests Punto 4 Fran

test("En Weise se recuerda destruir al rey demonio en 1400", nondet):-
    seRecuerdaEn(weise, destruirReyDemonio, 1400).
test("En Klares se recuerda rescatar a la hermana de Wirbel en 1395", nondet):-
    seRecuerdaEn(klares, rescatarHermanaWirbel, 1395).
test("En Klares no se recuerda destruir al rey demonio en 1395"):-
    \+ seRecuerdaEn(klares, destruirReyDemonio, 1395).

test("En Weise se leyeron 100 paginas en 1335", nondet):-
    paginasLeidasEn(weise, 1335, 100).
test("En Weise se leyeron 0 paginas en 1336", nondet):-
    paginasLeidasEn(weise, 1336, 0).

test("Ende es el pueblo mas lector en 1400", nondet):-
    puebloMasLector(ende, 1400).
test("Weise no es el pueblo mas lector en 1400"):-
    \+ puebloMasLector(weise, 1400).

test("Auberst es musical en 1395", nondet):-
    puebloMusical(auberst, 1395).
test("Weise no es musical en 1400"):-
    \+ puebloMusical(weise, 1400).

test("Ende es chismoso en 1420 ya que solo se recuerda destruir al demonio Aura que no esta corroborada", nondet):-
    puebloChismoso(ende, 1420).
test("Weise no es chismoso en 1400"):-
    \+ puebloChismoso(weise, 1400).

test("destruir al rey demonio es importante para Weise en 1400", nondet):-
    hazaniaImportantePara(weise, destruirReyDemonio, 1400).
test("recuperar al gato perdido no es importante para Weise en 1400 (solo Kanne la recuerda)"):-
    \+ hazaniaImportantePara(weise, recuperarGatoPerdido, 1400).

test("Klares vive tiempos sin precedentes en 1395", nondet):-
    viveTiemposSinPrecedentes(klares, 1395).
test("Weise no vive tiempos sin precedentes en 1400, destruir al rey demonio es importante para Weise pero nadie de alli presencio esa hazana"):-
    \+ viveTiemposSinPrecedentes(weise, 1400).

:- end_tests(tpIntegrador).