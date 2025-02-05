****************************************************************
**************************28/01/2025****************************
**************************Haciendo Econ*************************
**********************Francisco Sarmiento***********************
**************************Sofia Bohada**************************
************************Alejandro Arias*************************
****************************Taller 1****************************
****************************************************************

***************************************************************
* 0. Cargar base de datos y descripción
***************************************************************
cd "C:\Users\alejo\Documents\GitHub\Haciendo-Econom-a"
use "Raw\TenderosFU03_Publica.dta", replace
describe

***************************************************************
* 1. Identificar y resumir variables para el taller
*    (Nuevas incluidas)
***************************************************************
sum Solic_Credito Pres_Bancario Cuent_Separad Elec_Wallet_Knowledge Elec_Wallet_Uso ///
    Finan_Gastos__1 Finan_Gastos__2 Finan_Gastos__4 Porcent_Ahorr Amigos_Prestamo ///
    Pres_Partic_Cred Opinion_Pago_Digital

***************************************************************
* 2. Tabular la distribución de las variables
***************************************************************
tab Cuent_Separad, missing
tab Elec_Wallet_Knowledge, missing
tab Elec_Wallet_Uso, missing
tab Solic_Credito, missing
tab Pres_Bancario, missing

* Tabulaciones adicionales (nuevas variables)
tab Finan_Gastos__1, missing
tab Finan_Gastos__2, missing
tab Finan_Gastos__4, missing
tab Finan_Gastos__7, missing
tab Finan_Gastos__9, missing
tab Finan_Gastos__10, missing
tab Finan_Gastos__11, missing
tab Finan_Gastos__12, missing

tab Porcent_Ahorr, missing
tab Amigos_Prestamo, missing
tab Pres_Partic_Cred, missing
tab Opinion_Pago_Digital, missing

***************************************************************
* 3. Gráficas sobre solicitud de crédito y productos financieros
***************************************************************

* 3.1 Gráfica de Solic_Credito
graph bar (percent), over(Solic_Credito, label(angle(45))) ///
    ytitle("Porcentaje de micronegocios") ///
    title("¿Se ha solicitado algún crédito en los últimos 12 meses?") ///
    subtitle("n=1,222 | Sí=17.84% | No=61.05% | No sabe=4.91% | Missing=16.20%", size(small)) ///
    bargap(30) ///
    name(gSolic_Credito, replace)

graph export "Output\Solic_Credito.eps", as(eps) replace

***************************************************************
* 3.2 Gráfica de Pres_Bancario con fuente reducida
***************************************************************
local NL = char(10)
label define Pres_Bancario ///
    1  "Sí, y lo acepté"    ///
    2  "Sí, pero me lo negaron"  ///
    3  "Sí, pero no lo acepté"   ///
    4  "No", replace

graph bar (percent), over(Pres_Bancario, label(angle(46))) ///
    ytitle("Porcentaje de micronegocios", size(small)) ///
    title("¿Se solicitó un crédito bancario?", ///
          justification(center) size(medsmall)) ///
    subtitle("n=1,222 | Otorgado-Aceptado=11.78% | Negado=1.55% | No=4.17% | Missing=82.16%", size(vsmall)) ///
    bargap(30) ///
    name(gPres_Bancario, replace)

graph export "Output\Pres_Bancario.eps", as(eps) replace

***************************************************************
* 3.3 Gráfica comparativa de variables binarias
***************************************************************
graph bar (mean) Cuent_Separad Elec_Wallet_Knowledge Elec_Wallet_Uso, ///
    bargap(30) ///
    title("Proporción de micronegocios con productos financieros", ///
          justification(center) size(medsmall)) ///
    ytitle("Proporción (media)", size(small)) ///
    legend(order(1 "Cta Ahorros exclusiva" ///
                 2 "Usa billeteras electrónicas" ///
                 3 "Conoce billeteras electrónicas") ///
           size(small)) ///
    note("n=1,222 | Cta Exclusiva: 25.94% |  Conoce billeteras: 77% |  Usa billeteras: 62.19% (281 missing)", size(vsmall)) ///
    name(gBinariasCluster, replace)

graph export "Output\BinariasCluster.eps", as(eps) replace

***************************************************************
* 4. Gráficas sobre Finan_Gastos y Porcent_Ahorr
***************************************************************
* 4.1 Comparativa de Finan_Gastos
graph bar (mean) Finan_Gastos__1 Finan_Gastos__2 Finan_Gastos__4 ///
               Finan_Gastos__7 Finan_Gastos__9 Finan_Gastos__10 ///
               Finan_Gastos__11 Finan_Gastos__12, ///
    bargap(30) asyvars ///
    title("Formas de Financiar Gastos Regulares") ///
    ytitle("Proporción que Aplica") ///
    legend(order(1 "Ahorro" 2 "Ganancias" 3 "Pres. Banco" ///
                 4 "Gob" 5 "Amigos" 6 "Pres. no Banco" ///
                 7 "No necesita" 8 "Otro")) ///
    name(gFinanGastosAll, replace)

graph export "Output\FinanGastos.eps", as(eps) replace

* 4.2 Distribución de Porcent_Ahorr (histograma)
histogram Porcent_Ahorr, start(0) width(10) ///
    title("Distribución del porcentaje de ahorro (agrupado por decenas)") ///
    ylabel(, angle(0)) ///
    name(gHistAhorr, replace)
	


graph export "Output\HistAhorr.eps", as(eps) replace

***************************************************************
* 5. Gráficas sobre créditos informales y opinión de pagos digitales
***************************************************************
* 5.1 Amigos_Prestamo (Pregunta 506)

label define opinPago2 1 "Si-Acepté" 2 "" 3 "Si-No acepté" 4 "No", replace

* 2. Asigna dichas etiquetas a la variable
label values Amigos_Prestamo opinPago2

graph bar (percent), over(Amigos_Prestamo) ///
    title("¿Se solicitó préstamo a amigos/parientes sin intereses?") ///
    ytitle("Porcentaje de micronegocios") ///
    bargap(30) ///
    name(gAmigos, replace)

graph export "Output\AmigosPrestamo.eps", as(eps) replace

* 5.2 Pres_Partic_Cred (Pregunta 507)
graph bar (percent), over(Pres_Partic_Cred) ///
    title("¿Crédito con prestamista particular, casa de empeño o gota a gota?") ///
    ytitle("Porcentaje de micronegocios") ///
    bargap(30) ///
    name(gPartic, replace)

graph export "Output\PresParticCred.eps", as(eps) replace

* 5.3 Opinion_Pago_Digital (Pregunta 515)
* 1. Define las etiquetas (value label)
label define opinPago 1 "No, gastos extra" 2 "No-No utilidad" 3 "Útiles-ventas" 4 "Útiles-alternativas"

* 2. Asigna dichas etiquetas a la variable
label values Opinion_Pago_Digital opinPago

* 3. Genera la gráfica
graph bar (percent), ///
    over(Opinion_Pago_Digital, label(angle(45))) ///
    title("Opinión sobre pagos digitales") ///
    ytitle("Porcentaje de micronegocios") ///
    bargap(30) ///
    name(gOpDig, replace)
graph export "Output\OpinionPagoDigital.eps", as(eps) replace
