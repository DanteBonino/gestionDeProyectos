/*
Functor Tarea:
tarea(nombre, duracion,tareasAnterioresRequeridas).

Functor TareaOpcional: -> No tienen tareasAnterioresRequeridas
tareaOpcional(nombre, cantidadPersonas, duracion).
*/

proyecto(saeta, tarea(planificacion, 3, [])).
proyecto(saeta, tarea(encuesta, 5, [planificacion])).
proyecto(saeta, tarea(analisis, 5, [encuesta])).
proyecto(saeta, tarea(limpieza, 3, [planificacion])).
proyecto(saeta, tarea(diseno, 6, [analisis])).
proyecto(saeta, tarea(construccion, 5, [diseno, limpieza])).
proyecto(saeta, tarea(ejecucion, 4, [construccion])).
proyecto(saeta, tareaOpcional(presentacion, 4, 10)).

%Punto 1:
tareaSiguiente(UnaTarea, OtraTarea):-
    tareaDeProyecto(Proyecto,OtraTarea,_,_,TareasAnteriores),
    tareaDeProyecto(Proyecto,UnaTarea,Nombre,_,_),
    member(Nombre, TareasAnteriores).

tareaDeProyecto(Proyecto, Tarea, Nombre, Duracion, TareasAnterioresOCantidadPersonas):-
    proyecto(Proyecto,Tarea),
    atributosTarea(Tarea, Nombre, Duracion, TareasAnterioresOCantidadPersonas).

atributosTarea(tarea(Nombre,Duracion,TareasAnteriores),Nombre,Duracion,TareasAnteriores).
atributosTarea(tareaOpcional(Nombre,CantidadPersonas,Duracion), Nombre, Duracion, CantidadPersonas).

%Punto 2:
esPesada(Tarea):-
    tareaSiguiente(UnaTareaSiguiente, Tarea),
    tareaSiguiente(OtraTareaSiguiente, Tarea),
    UnaTareaSiguiente \= OtraTareaSiguiente.
esPesada(Tarea):-
    duracionTareaDeProyecto(_,Tarea,Duracion),
    Duracion > 5.
esPesada(Tarea):-
    cantidadPersonas(_,Tarea, 1).

duracionTareaDeProyecto(Proyecto, Tarea, Duracion):-
    tareaDeProyecto(Proyecto, Tarea,_,Duracion,_).

cantidadPersonas(Proyecto, Tarea, Cantidad):-
    tareaDeProyecto(Proyecto,Tarea,_,_,Cantidad).

%Punto 3:
tipoDeTarea(Tarea, Tipo):-
    tareaDeProyecto(_,Tarea,_,_,_),
    tipoTarea(Tarea,Tipo).

tipoTarea(Tarea, final):-
    not(tieneSiguiente(Tarea)).
tipoTarea(Tarea, inicial):-
    not(tieneAnterior(Tarea)).
tipoTarea(Tarea, intermedia):-
    tieneSiguiente(Tarea),
    tieneAnterior(Tarea).

tieneSiguiente(Tarea):-
    tareaSiguiente(Tarea, _).
tieneAnterior(Tarea):-
    tareaSiguiente(_, Tarea).

%Punto 4:
camino(TareaInicial, TareaFinal, ListaDeTareas):-
    primerTarea(ListaDeTareas, PrimerTarea),
    ultimaTarea(ListaDeTareas, UltimaTarea),
    tareaSiguiente(TareaInicial, PrimerTarea),
    tareaSiguiente(UltimaTarea, TareaFinal),
    forall(member(Tarea, ListaDeTareas), tareaAdyacente(Tarea,ListaDeTareas)),
    not(member(TareaInicial, ListaDeTareas)),
    not(member(TareaFinal, ListaDeTareas)).

tareaAdyacente(Tarea, ListaDeTareas):-
    posicionDeTareaDeProyecto(Tarea, ListaDeTareas, Posicion),
    posicionDeTareaDeProyecto(OtraTarea, ListaDeTareas, OtraPosicion),
    abs(Posicion-OtraPosicion, 1),
    algunoEsSiguienteDe(Tarea, OtraTarea).

algunoEsSiguienteDe(Tarea,OtraTarea):-
    tareaSiguiente(Tarea, OtraTarea).
algunoEsSiguienteDe(Tarea,OtraTarea):-
    tareaSiguiente(OtraTarea,Tarea).

ultimaTarea(Lista, Ultima):-
    length(Lista,Length),
    nth1(Length, Lista, Ultima).

primerTarea(Lista, Primera):-
    nth1(1, Lista, Primera).

posicionDeTareaDeProyecto(Tarea, ListaDeTareas, Posicion):-
    tareaDeProyecto(_,Tarea,_,_,_),
    nth1(Posicion, ListaDeTareas, Tarea).

%Punto 5:
caminoPesado(Camino):-
    camino(_,_,Camino),
    forall(member(Tarea,Camino), esPesada(Tarea)),
    duracionTotal(Camino, Duracion),
    Duracion > 100.

duracionTotal(Camino, DuracionTotal):-
    findall(Duracion, duracionTareaDeCamino(Camino, Duracion), Duraciones),
    sum_list(Duraciones, DuracionTotal).

duracionTareaDeCamino(Camino, Duracion):-
    member(Tarea, Camino),
    duracionTareaDeProyecto(_,Tarea, Duracion).

%Punto 6:
cantidadDeTareasAnteriores(Tarea, Cantidad):-
    tareaDeProyecto(_,Tarea,_,_,_),
    findall(TareaAnterior,tareaAnterior(Tarea, TareaAnterior), Anteriores),
    sort(Anteriores, AnterioresSinRepetidas),
    length(AnterioresSinRepetidas, Cantidad).

tareaAnterior(Tarea, OtraTarea):-
    tareaSiguiente(OtraTarea, Tarea).
tareaAnterior(Tarea, OtraTarea):-
    tareaSiguiente(OtraTarea, UnaTarea),
    tareaAnterior(Tarea, UnaTarea).
    