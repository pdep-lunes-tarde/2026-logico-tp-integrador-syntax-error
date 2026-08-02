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

% Punto 2 (Fran)
% presencio(Persona, Hazania, AnioEnQuePreseencio, LugarSegunEsaPersona, HeroesSegunEsaPersona)
presencio(wirbel, rescatarHermanaWirbel, 1390, klares, [strak, fern]).
presencio(frieren, rescatarHermanaWirbel, 1390, klares, [strak, fern]).
presencio(kanne, recuperarGatoPerdido, 1375, weise, [himmel, frieren]).
% escucho(Persona, Hazania, AnioEnQueEscucho, LugarSegunEsaPersona, HeroesSegunEsaPersona)
escucho(lawine, destruirDemonioAura, 1393, weise, [frieren]).
% leyo(Persona, Hazania, AnioEnQueLeyo, Paginas, LugarSegunEsaPersona, HeroesSegunEsaPersona)
leyo(voll, destruirDemonioAura, 1400, 50, auberst, [denek]).
leyo(serie, destruirReyDemonio, 1335, 100, ende, [frieren, himmel, heiter, eisen]).
% a) 
recuerdaHazania(Persona, Hazania, AnioActual) :-
    presencio(Persona, Hazania, AnioPresencio, _, _),
    AnioPresencio =< AnioActual,
    estaVivo(Persona, AnioActual).

recuerdaHazania(Persona, Hazania, AnioActual) :-
    escucho(Persona, Hazania, AnioEscucho, _, _),
    AnioActual >= AnioEscucho,
    AnioActual =< AnioEscucho + 15,
    estaVivo(Persona, AnioActual).

recuerdaHazania(Persona, Hazania, AnioActual) :-
    leyo(Persona, Hazania, AnioLeyo, Paginas, _, _),
    AnioActual >= AnioLeyo,
    AnioActual =< AnioLeyo + Paginas,
    estaVivo(Persona, AnioActual).

% b)
version(Hazania, Lugar, HeroesOrdenados) :-
    presencio(_, Hazania, _, Lugar, Heroes),
    sort(Heroes, HeroesOrdenados).

version(Hazania, Lugar, HeroesOrdenados) :-
    escucho(_, Hazania, _, Lugar, Heroes),
    sort(Heroes, HeroesOrdenados).

version(Hazania, Lugar, HeroesOrdenados) :-
    leyo(_, Hazania, _, _, Lugar, Heroes),
    sort(Heroes, HeroesOrdenados).
 
hazaniaCorroborada(Hazania) :-
    findall((Lugar, Heroes), version(Hazania, Lugar, Heroes), Versiones),
    sort(Versiones, VersionesUnicas),
    length(VersionesUnicas, 1).



% c)
conocioHazania(Persona, Hazania) :- presencio(Persona, Hazania, _, _, _).
conocioHazania(Persona, Hazania) :- escucho(Persona, Hazania, _, _, _).
conocioHazania(Persona, Hazania) :- leyo(Persona, Hazania, _, _, _, _).

pasoAlOlvido(Hazania, Anio) :-
    conocioHazania(_, Hazania),
    \+ ( conocioHazania(Persona, Hazania), recuerdaHazania(Persona, Hazania, Anio) ).

% Punto 3 (Andrea)
% a)
% diaFestivo(Pueblo, Hazania, AñoInicio)
diaFestivo(weise, destruirReyDemonio, 1340).

% estatua(Pueblo, Material, Nombre, Hazania, AñoConstruccion)
estatua(auberst, bronce, equipoHeroes, destruirReyDemonio, 1370).
estatua(auberst, marmol, heroeDelSur, destruirSchlatOmnisciente, 1340).

% mantenimiento(Estatua, Año)
mantenimiento(equipoHeroes, 1400).
mantenimiento(equipoHeroes, 1450).
mantenimiento(heroeDelSur, 1410).

% b)
duracionMaterial(marmol,30).
duracionMaterial(bronce,15).

% último mantenimiento ocurrido hasta el año consultado
ultimoMantenimiento(Estatua, AnioActual, AnioMantenimiento):-
    mantenimiento(Estatua, AnioMantenimiento),
    AnioMantenimiento =< AnioActual,
    \+ (
        mantenimiento(Estatua, Otro),
        Otro =< AnioActual,
        Otro > AnioMantenimiento
    ).

% último cuidado = último mantenimiento o construcción
ultimoCuidado(Estatua, AnioActual, Ultimo):-
    ultimoMantenimiento(Estatua, AnioActual, Ultimo).

ultimoCuidado(Estatua, AnioActual, Construccion):-
    estatua(_, _, Estatua, _, Construccion),
    Construccion =< AnioActual,
    \+ (
        mantenimiento(Estatua, M),
        M =< AnioActual
    ).

estatuaEnBuenEstado(Estatua, AnioActual):-
    estatua(_, Material, Estatua, _, _),
    ultimoCuidado(Estatua, AnioActual, Ultimo),
    duracionMaterial(Material, Duracion),
    AnioActual =< Ultimo + Duracion.

% si nació después de la conmemoración, la conoce al nacer
% si ya había nacido, la conoce cuando empieza la conmemoración
anioConocimiento(Persona, InicioConmemoracion, Anio):-
    habitante(Persona, _, Nacimiento, _),
    Anio is max(Nacimiento, InicioConmemoracion).

% recuerda por día festivo
recuerdaHazania(Persona, Hazania, AnioActual):-
    habitante(Persona, _, _, Pueblo),
    diaFestivo(Pueblo, Hazania, Inicio),
    anioConocimiento(Persona, Inicio, Desde),
    AnioActual >= Desde,
    estaVivo(Persona, AnioActual).

% recuerda por estatua
recuerdaHazania(Persona, Hazania, AnioActual):-
    habitante(Persona, _, _, Pueblo),
    estatua(Pueblo, _, Estatua, Hazania, Inicio),
    anioConocimiento(Persona, Inicio, Desde),
    AnioActual >= Desde,
    estatuaEnBuenEstado(Estatua, AnioActual),
    estaVivo(Persona, AnioActual).

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