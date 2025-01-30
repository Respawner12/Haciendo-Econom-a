***************************************************************
**************************28/01/2025***************************
**************************Haciendo Econ************************
**********************Francisco Sarmiento**********************
**************************Sofia Bohada*************************
************************Alejandro Arias************************
****************************Taller 1***************************
***************************************************************

***************************************************************
*Cargar base de datos
***************************************************************
cd "C:\Users\alejo\Documents\GitHub\Haciendo-Econom-a"

use "Raw\TenderosFU03_Publica.dta", replace
describe

***************************************************************
*Se identifican las variables que se usarán en el taller
***************************************************************
sum Solic_Credito Pres_Bancario Cuent_Separad Elec_Wallet_Knowledge Elec_Wallet_Uso

***************************************************************
*Tabular la distribución de las variables
***************************************************************
tab Cuent_Separad, missing
tab Elec_Wallet_Knowledge, missing
tab Elec_Wallet_Uso, missing
tab Solic_Credito, missing
tab Pres_Bancario, missing

***************************************************************
* 1. Gráfica de Solic_Credito (sin cambios solicitados)
***************************************************************
graph bar (percent), over(Solic_Credito, label(angle(45))) ///
    ytitle("Porcentaje de micronegocios") ///
    title("¿Se ha solicitado algún crédito en los últimos 12 meses?") ///
    subtitle("n=1,222 | Sí=17.84% | No=61.05% | No sabe=4.91% | Missing=16.20%", size(small)) ///
    bargap(30) ///
    name(gSolic_Credito, replace)

graph export "Output\Solic_Credito.jpg", as(jpg) replace	
	
***************************************************************
* 2. Gráfica de Pres_Bancario con fuente reducida
***************************************************************

local NL = char(10)
label define Pres_Bancario ///
    1  "Sí, y lo acepté"    ///
    2  "Sí, pero me lo negaron"                   ///
    3  "Sí, pero no lo acepté" ///
    4  "No", replace

graph bar (percent), over(Pres_Bancario, label(angle(46))) ///
    ytitle("Porcentaje de micronegocios", size(small)) ///
    title("¿Se solicitó un crédito bancario?", ///
          justification(center) size(medsmall)) ///
    subtitle("n=1,222 | Otorgado-Aceptado=11.78% | Negado=1.55% | No=4.17% | Missing=82.16%", size(vsmall)) ///
    bargap(30) ///
    name(gPres_Bancario, replace)
	
graph export "Output\Pres_Bancario.jpg", as(jpg) replace

***************************************************************
* 3. Gráfica comparativa de variables binarias
*    con título centrado y leyenda personalizada
***************************************************************
graph bar (mean) Cuent_Separad Elec_Wallet_Knowledge Elec_Wallet_Uso, ///
    bargap(30) ///
    title("Proporción de micronegocios con productos financieros", ///
          justification(center) size(medsmall)) ///
    ytitle("Proporción (media)", size(small)) ///
    legend(order(1 "Cta Ahorros exclusiva" ///
                 2 "Conoce billeteras electrónicas" ///
                 3 "Usa billeteras electrónicas") ///
           size(small)) ///
    note("n=1,222 | Cta Exclusiva: 25.94% |  Conoce billeteras: 77% |  Usa billeteras: 62.19% (281 missing)", size(vsmall)) ///
    name(gBinariasCluster, replace)
	
graph export "Output\BinariasCluster.jpg", as(jpg) replace
