(deffacts default
    (robot 0 max 3 current 0)
    (palets 4)
    (palet 1 naranjas cajas 5)
    (palet 2 manzanas cajas 3)
    (palet 3 caquis cajas 0)
    (palet 4 uvas cajas 2)
    (pedido naranjas 4 manzanas 1 caquis 0 uvas 1)
    (recogido naranjas 0 manzanas 0 caquis 0 uvas 0)
)

(defrule coger_caja
    (declare (salience 10))
    ?r <- (robot ?pos max ?max current ?current)
    ?p <- (palet ?num ?prod cajas ?cajas)
    (pedido $?ini ?tipo ?n $?fin )
    ?rec <- (recogido $?ini2 ?tipo2 ?n2 $?fin2 )
    (test (and (= ?pos ?num) (eq ?tipo ?prod)))
    (test (and (< ?current ?max) (> ?cajas 0)))
    (test (and (eq ?tipo ?tipo2) (< ?n2 ?n)))
    =>
    (retract ?r)
    (retract ?p)
    (retract ?rec)
    (assert (robot ?pos max ?max current (+ ?current 1)))
    (assert (palet ?num ?prod cajas (- ?cajas 1)))
    (assert (recogido $?ini2 ?tipo2 (+ ?n2 1) $?fin2))
    ( printout t "He cogido una caja" crlf )
)

(defrule mover_derecha
    (declare (salience 5))
    ?r <- (robot ?pos max ?max current ?current)
    (palets ?n)
    (test (and (< ?pos ?n) (< ?current ?max) ))
    =>
    ( printout t "Moviendo" crlf )
    (retract ?r)
    (assert (robot (+ ?pos 1) max ?max current ?current))
)

(defrule entregar
    (declare (salience 15))
    (robot ?pos max ?max current ?current)
    (pedido $?x)
    (recogido $?y)
    (test (eq $?x $?y))
    =>
    (assert (robot 0 max ?max current ?current)) 
    ( printout t "Pedido entregado" crlf )
    (halt)
)

(defrule entregar_parte
    (declare (salience 14))
    ?r <- (robot ?pos max ?max current ?current)
    (test (= $?max $?current))
    =>
    (retract ?r)
    (assert (robot 0 max ?max current 0)) 
    ( printout t "Parte del pedido entregado" crlf )
)

(defrule no_hay_suficientes
	(pedido $?ini ?tipo ?n $?fin )
	(palet ?num ?prod cajas ?cajas)
	(test (and (eq ?tipo ?prod) (< ?cajas ?n)) )
	=> 
	( printout t "No hay suficientes cajas" crlf )
	(halt)
)