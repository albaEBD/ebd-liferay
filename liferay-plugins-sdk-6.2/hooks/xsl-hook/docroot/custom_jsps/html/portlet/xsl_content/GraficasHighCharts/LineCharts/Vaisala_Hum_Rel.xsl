<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>	

<!--  
XSL que muestra las 4,5 y 6 primeras variables del XML, que en este caso se refieren al Vel_Viento_Min, Vel_Viento_Med 
y Vel_Viento_Max de la Vaisala. 

PARAMETROS A CONFIGURAR

1.- Variable XLS "prefijo: Cada gráfica debe tener un sufijo distinto para diferenciar los
componentes HTML, las variables en el LocalStorage y las variables XLS
<xsl:variable name="sufijo" >
	<xsl:value-of select="'MultiLine9'"/>
</xsl:variable>

2.- Array con parámetros seleccionados para mostrar en la gráfica
var parametrosMostrados 

3.- Número de variables que se pueden mostrar en la gráfica (num variables que se parsean del XML)
var numeroVariablesGrafica 	 

4.- Copiar el código XSL y HMTL al final de este archivo según el número de variables.


 -->



	<xsl:strip-space elements="*"/>
	
	<xsl:template match="root">
	<html>
		<head></head> 
		<body> 
			<xsl:apply-templates select="environment"></xsl:apply-templates> <!-- template para datos del sensor-->
			<xsl:apply-templates select="data"></xsl:apply-templates> <!--template para grafica-->
		</body>
		</html>
	</xsl:template>


 <xsl:template match="environment"> 
 <!-- template que recoge valores de: nombre de la estacion y num serie del sensor? -->
  	 <div><h1><xsl:value-of select="station-name"/><br/></h1></div>
  	<xsl:variable name="nserie" >
			<xsl:value-of select="serial-no"/>
  	</xsl:variable>	
  	  
 </xsl:template>
 
 
<xsl:template match="data">
<!-- plantilla para gestión de los datos-->
<div>

  

  	
<xsl:text disable-output-escaping="yes">
      			<![CDATA[<script src='http://code.jquery.com/jquery-1.9.1.js'> </script>]]>
      			<![CDATA[<script src='http://code.highcharts.com/highcharts.js'> </script>]]>
      			<!-- <![CDATA[<script  language="JavaScript" src='/html/portlet/xsl_content/FuncionesAuxiliares.min.js'> </script>]]>-->
      				
      			<![CDATA[
				<script> 
				
      			/*
				 * Función para ocultar los objectos canvas
				 */
				function ocultarCanvas(){    
				
					var divs = document.getElementsByTagName("canvas"), item;
						 for (var i = 0, len = divs.length; i < len; i++) {
						    item = divs[i];
						    item.style.display = "none";						    
					 }
				}     
				
				/*
				 * Función para ocultar los objectos div cuyo id sea container 
				 * (son div que contienen las gráficas)
				 */
				function ocultarContainer(sufijo){ 
				
					var divs = document.getElementsByTagName("div"), item;
					
					for (var i = 0, len = divs.length; i < len; i++) {
					 		
					 		//Ocultamos la grafica
					 		item = divs[i];
					 		
					 		
					 		if(item.id.indexOf("container") > -1 && item.id.split("_").pop() == sufijo){
					 			//alert(item.id);
					 			item.style.display = "none";
					    }
					}		
				}
				
				
				/*!
				 * Función para ocultar los objectos div cuyo id sea container 
				 * (son div que contienen las gráficas)
				 */
				function ocultarCheckboxs (parametros,sufijo){
					
					//alert("entra en ocultarCheckboxs  con sufijo " + sufijo)
					
					var divs = document.getElementsByTagName("div"), item;
					
					
					for (var i = 0, len = divs.length; i < len; i++) {
						item = divs[i];
					    //Ocultamos los checkboxs que no están el vector
					    var contenido = 0;
					    
					    
					    
					    if(item.id.indexOf("checkbox") > -1 && item.id.split("_").pop() == sufijo){
					    
					    
				 			for(var j=0; j < parametros.length; j++){
					 			if(item.id.indexOf(parametros[j]) > -1){
					 				contenido=1;
					 			}
					 		}
					 		/* Si no se encuentra el id entre los parametros seleccionados se oculta*/
					 		if(contenido==0){
					 			item.style.display = "none";
					 		}
					 	}
						    						    
					 }
					 
					 //alert("FIN ocultarCheckboxs 1");
				}
				
			/*Función que almacena en el localStorage los datos correspondientes a los valores de tiempo (ejeX), los datos (ejeY), la variable y unidad*/
      			
   			function almacenar(nserie,posicion,etiquetas,datos,vable,unit,sufijo)  
   			{ 
   				window.localStorage.removeItem(nserie+"_etiquetas_meteo"+posicion+"_"+sufijo); //borra el valor antiguo del localStorage
   				window.localStorage.setItem(nserie+"_etiquetas_meteo"+posicion+"_"+sufijo,etiquetas); //almacena el valor nuevo en el localStorage 
   				
   				window.localStorage.removeItem(nserie+"_datos_meteo"+posicion+"_"+sufijo);
   				window.localStorage.setItem(nserie+"_datos_meteo"+posicion+"_"+sufijo,datos);
   				
   				window.localStorage.removeItem(nserie+"_variable_meteo"+posicion+"_"+sufijo);
   				window.localStorage.setItem(nserie+"_variable_meteo"+posicion+"_"+sufijo,vable);
   				
   				window.localStorage.removeItem(nserie+"_unidad_meteo"+posicion+"_"+sufijo);
   				window.localStorage.setItem(nserie+"_unidad_meteo"+posicion+"_"+sufijo,unit);
			}
			
		/* Función para pintar las gráficas
          - nserie: numero de serie del sensor
          - mode: distingue entre recarga del portlet y el hacer click al boton
          - numeroVariablesGrafica: num variables en la grafica
          - Sufijo: que diferencia las variables y los elementos html de un portlet a otro
         */
         
         function pintarGraficas(nserie,mode,numeroVariablesGrafica,sufijo){
         	
         	
         	var i=0;
         	for(i=1;i<numeroVariablesGrafica+1;i++){ 
         		
         		
         		if(document.getElementById("v"+i+"_"+sufijo) && document.getElementById("v"+i+"_"+sufijo).checked){       
	         		console.log("opcion 1 con i " + i);
	         		window.localStorage.setItem(nserie+"_container_"+i+"_"+sufijo,"checked"); 
	         		document.getElementById(nserie+"_container_"+sufijo).style.display = "";
	         		pintar(1,nserie,numeroVariablesGrafica,sufijo);  
	         	}else{         	
	         		if(window.localStorage.getItem(nserie+"_container_"+i+"_"+sufijo) && window.localStorage.getItem(nserie+"_container_"+i+"_"+sufijo)=="checked" && mode == "reload"){
	         			if(document.getElementById(nserie+"_container_"+sufijo)){
		         			console.log("opcion 2 con i " + i);
		         			document.getElementById(nserie+"_container_"+sufijo).style.display = "";
		         			document.getElementById("v"+i+"_"+sufijo).checked=true;
		         			pintar(1,nserie,numeroVariablesGrafica,sufijo);   
		         			  
	         			} 	
	         			
	         			
	         		}else{ 
	         			console.log("opcion 3.0 con i " + i);
	         			if(document.getElementById(nserie+"_container_"+sufijo)){   
	         				window.localStorage.removeItem(nserie+"_container_"+i+"_"+sufijo); 
	         				window.localStorage.setItem(nserie+"_container_"+i+"_"+sufijo,"unchecked");
	         						
	         			}
	         		}
	         	}
         	}
         	
         	//Si todos estan unchecked se oculta la grafica
         	var ocultar = 1;
         	for(i=1;i<numeroVariablesGrafica+1;i++){
         	 	if(window.localStorage.getItem(nserie+"_container_"+i+"_"+sufijo)=="checked"){
         	 		ocultar=0;         	 	
         		}
         	}
         	if(ocultar==1){
         		document.getElementById(nserie+"_container_"+sufijo).style.display = "none";   
         	}
         	
         } 
				
	</script>]]>      			
      		</xsl:text>


<!-- IMPORTANTE: DEBEMOS DEFINIR UN SUFIJO QUE SEA DIFERENTE EN CADA GRAFICA DE LA MISMA PÁGINA.
Esto permite distinguir en el LocalStorage del navegador las variables de esta grafica con las demás.-->     		
<xsl:variable name="sufijo" >
	<xsl:value-of select="'Grafica3'"/>
</xsl:variable>	      		
      		
      		
      		
 <xsl:variable name="nserie" >
	<xsl:value-of select="/csixml/head/environment/serial-no"/>
</xsl:variable>

  	
<xsl:variable name="Title" >
	<xsl:value-of select="/csixml/head/environment/table-name"/>
</xsl:variable>  	
  	
  	
 <xsl:variable name="container" >
	<xsl:value-of select="concat(concat($nserie,'_container_'),$sufijo)"/>
</xsl:variable>	  

      		
      		
<div id="{$container}" name="{$container}" style="min-width: 400px; height: 400px; margin: 0 auto"></div> 
      		
      		
<xsl:text disable-output-escaping="yes">
      			<![CDATA[
				<script> 
				//Definición de variables globales
				
				//IMPORTANTE: CAMBIAR ESTAS DOS VARIABLES GLOBALES
				
				//Parámetros seleccionados para mostrar en la gráfica
				var parametrosMostrados = ["Hum_Rel"];
				 
				//Número de variables que se pueden mostrar en la gráfica (num variables que se parsean)
				var numeroVariablesGrafica = 9;		
				
				
				/*window.onload = function() {
					//alert("inicio onload HighChart 1");					 
					ocultar();
					//alert("fin onload HighChart 1");
				}*/
				
				
				/* Al inicio ocultamos la gráfica y las variables que no esten en el vector, 
					esperando que el usuario seleccione una opción*/
				function ocultar(){
						ocultarCanvas();
						ocultarContainer(']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
						ocultarCheckboxs(parametrosMostrados,']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');						
				}
				
				
      			</script>
			]]> 
      		</xsl:text>		
      		
      		
		<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	
 		<script> 
 		/* Función que pinta la grafica, pasamos el valor del boton 
 		que determina la variable a pintar y el num serie del sensor */       
       
        function pintar (valor,nserie,numeroVariablesGrafica,sufijo){
        
        window.localStorage.removeItem(nserie+"_valor_meteo"); //Almacenamos el nuevo valor del botón pulsado (por si el usuario cambia la variable a mostrar)
      	window.localStorage.setItem(nserie+"_valor_meteo_"+sufijo,valor);
      	
      	// ETIQUETAS 
    	var alm_etiquetas=nserie+"_etiquetas_meteo"+valor+"_"+sufijo; //Recuperamos los datos correspondientes a la vble seleccionada
      	var etiquetas=window.localStorage.getItem(alm_etiquetas); //Tiempo para el ejeX
    	var etiq = etiquetas.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
      	
      	for	(index = 0; index < etiq.length; index++) {
    		var aux = etiq[index];
    		etiq[index] = aux.substring(aux.indexOf("T")+1,aux.length-3); 
    	}
      	
      	//  DATOS 
      	
      
      	var numVarChecked = 0;
      	
      	for	(i = 0; i < numeroVariablesGrafica; i++) {
      		if(document.getElementById("v"+(i+1)+"_"+sufijo).checked){
      			numVarChecked=numVarChecked+1;
      		}
      	}
      	
      	var datasetsGrafica = new Array(numVarChecked);
      	var cont = 0;
      	console.log("Tam datasets: " + datasetsGrafica.length);
     	
     	for	(i = 0; i < numeroVariablesGrafica; i++) {
      		if(document.getElementById("v"+(i+1)+"_"+sufijo).checked){
      			
      			var alm_datos=nserie+"_datos_meteo"+(i+1)+"_"+sufijo; //Datos para el ejeY 
      			var datos=window.localStorage.getItem(alm_datos);
      			var dat = datos.split(",");
      			for	(index = 0; index < dat.length; index++) {
		    		if (dat[index]!="NAN") //Si el valor es NAN se interpreta como vacio y se pinta como 0
		    		{
		    			dat[index] = parseFloat(dat[index]);
		    		}
		    		else
		    		{
		    			dat[index] = null;
		    		}
				}//for
				
				
				// Variable seleccionada (Para mostrar como leyenda)
				var labelVar=window.localStorage.getItem(nserie+"_variable_meteo"+(i+1)+"_"+sufijo);
				
				//Unidades (Para mostrar como leyenda)
				var units=window.localStorage.getItem(nserie+"_unidad_meteo"+(i+1)+"_"+sufijo);
				
				var JSONLine = {
					name: labelVar,
                    data : dat, 
                }
				datasetsGrafica[cont] = JSONLine; 
				cont =  cont + 1;
      		}//if
      	}//for
      	
      	
         	
         	var graficaDatos = { //Datos que pasamos a la función de la librería HighCharts
                labels : etiq,
                datasets : datasetsGrafica
            };
       
       			
           
            console.log("*** Configuración la gráfica HIGHCHARTS");
            
            var chart = new Highcharts.Chart({
            
				    chart: {
				        defaultSeriesType: 'spline',
				        renderTo: nserie + '_container_' + sufijo
				    },
				    title: {
			            text: ']]></xsl:text><xsl:value-of select="$Title" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
			            x: -20 //center
			        },
			        				
				    xAxis: {
				        categories: etiq
				    },
				    
				    yAxis: {
			            title: {
			                text: units
			            }
			        },
				
				    series:  datasetsGrafica
				
				});
				
            console.log("*** Fin Configuración gráfica HIGHCHARTS");
           
         }
         
         
         
         
        
            
</script> 
]]> 
    </xsl:text>	
    
    <xsl:variable name="nserie" >
			<xsl:value-of select="/csixml/head/environment/serial-no"/>
  	</xsl:variable>	
   
   
   
	<xsl:variable name="instante" > <!-- Recogemos todos los valores de tiempo del XML -->
	<xsl:for-each select="r">
		<xsl:value-of select="@time"/>
		<xsl:if test="following::node()">, </xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  
	<xsl:variable name="datos1" > 
	<xsl:for-each select="//v1">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v1">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble1" >
  		<xsl:value-of select="//field[1]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit1" >
  		<xsl:value-of select="//field[1]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',1,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos1" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble1" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit1" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    

    
    <xsl:variable name="datos2" >
	<xsl:for-each select="r/v2">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v2">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble2" >
  		<xsl:value-of select="//field[2]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit2" >
  		<xsl:value-of select="//field[2]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',2,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos2" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble2" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit2" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    
    <xsl:variable name="datos3" > 
	<xsl:for-each select="//v3">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v3">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble3" >
  		<xsl:value-of select="//field[3]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit3" >
  		<xsl:value-of select="//field[3]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',3,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos3" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble3" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit3" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>
    

    <xsl:variable name="datos4" > 
	<xsl:for-each select="//v4">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v4">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble4" >
  		<xsl:value-of select="//field[4]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit4" >
  		<xsl:value-of select="//field[4]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',4,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos4" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble4" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit4" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>
    
 
    <xsl:variable name="datos5" > 
	<xsl:for-each select="//v5">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v5">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble5" >
  		<xsl:value-of select="//field[5]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit5" >
  		<xsl:value-of select="//field[5]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',5,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos5" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble5" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit5" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>
    
    

        <xsl:variable name="datos6" > 
	<xsl:for-each select="//v6">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v6">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble6" >
  		<xsl:value-of select="//field[6]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit6" >
  		<xsl:value-of select="//field[6]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',6,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos6" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble6" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit6" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>
    
    
  <xsl:variable name="datos7" > 
	<xsl:for-each select="//v7">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v7">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble7" >
  		<xsl:value-of select="//field[7]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit7" >
  		<xsl:value-of select="//field[7]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',7,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos7" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble7" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit7" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>

  <xsl:variable name="datos8" > 
	<xsl:for-each select="//v8">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v8">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble8" >
  		<xsl:value-of select="//field[8]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit8" >
  		<xsl:value-of select="//field[8]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',8,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos8" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble8" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit8" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>  
    
          <xsl:variable name="datos9" > 
	<xsl:for-each select="//v9">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v9">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble9" >
  		<xsl:value-of select="//field[9]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit9" >
  		<xsl:value-of select="//field[9]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',9,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos9" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble9" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit9" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>   
	 
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init (nserie,sufijo){ 
      			//alert("H1");
      			ocultar();
	      		if (window.localStorage.getItem(nserie+"_valor_meteo_"+sufijo)) {
	      			pintarGraficas(nserie,"reload",numeroVariablesGrafica,sufijo);
				}   
			
		}
		init(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
		']]></xsl:text><xsl:value-of select="$sufijo" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	


	<!-- Creamos la variables de la propiedad name de los checkboxs -->
	<xsl:variable name="aux" >
		<xsl:value-of select="//field[1]/@name"/>
	</xsl:variable>
	
	  	
	 <xsl:variable name="name1_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id1_checkbox" >
		<xsl:value-of select="concat('v1_',$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="//field[2]/@name"/>
	</xsl:variable>
	
	  	
	 <xsl:variable name="name2_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id2_checkbox" >
		<xsl:value-of select="concat('v2_',$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="//field[3]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name3_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id3_checkbox" >
		<xsl:value-of select="concat('v3_',$sufijo)"/> 
	</xsl:variable>


	<xsl:variable name="aux" >
		<xsl:value-of select="//field[4]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name4_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id4_checkbox" >
		<xsl:value-of select="concat('v4_',$sufijo)"/> 
	</xsl:variable>
	
	
	<xsl:variable name="aux" >
		<xsl:value-of select="//field[5]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name5_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id5_checkbox" >
		<xsl:value-of select="concat('v5_',$sufijo)"/> 
	</xsl:variable>
	
		<xsl:variable name="aux" >
		<xsl:value-of select="//field[6]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name6_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id6_checkbox" >
		<xsl:value-of select="concat('v6_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="//field[7]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name7_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id7_checkbox" >
		<xsl:value-of select="concat('v7_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="//field[8]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name8_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id8_checkbox" >
		<xsl:value-of select="concat('v8_',$sufijo)"/> 
	</xsl:variable>
	
			<xsl:variable name="aux" >
		<xsl:value-of select="//field[9]/@name"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name9_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id9_checkbox" >
		<xsl:value-of select="concat('v9_',$sufijo)"/> 
	</xsl:variable>

	
    <!-- Punto de publicacion para las graficas -->
	 <table>
	 
	<tr><td>
		<div id="{$name1_checkbox}">
			<input type="checkbox"  value="1" id="{$id1_checkbox}" >
				<xsl:value-of select="//field[1]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name2_checkbox}">
			<input type="checkbox"  value="2" id="{$id2_checkbox}" >
				<xsl:value-of select="//field[2]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name3_checkbox}">
			<input type="checkbox"  value="3" id="{$id3_checkbox}" >
				<xsl:value-of select="//field[3]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name4_checkbox}">
			<input type="checkbox"  value="4" id="{$id4_checkbox}" >
				<xsl:value-of select="//field[4]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name5_checkbox}">
			<input type="checkbox"  value="5" id="{$id5_checkbox}" >
				<xsl:value-of select="//field[5]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name6_checkbox}">
			<input type="checkbox"  value="6" id="{$id6_checkbox}" >
				<xsl:value-of select="//field[6]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name7_checkbox}">
			<input type="checkbox"  value="7" id="{$id7_checkbox}" >
				<xsl:value-of select="//field[7]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name8_checkbox}">
			<input type="checkbox"  value="8" id="{$id8_checkbox}" >
				<xsl:value-of select="//field[8]/@name"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name9_checkbox}">
			<input type="checkbox"  value="9" id="{$id9_checkbox}" >
				<xsl:value-of select="//field[9]/@name"/>
			</input>
		</div>
	</td></tr>
	
	
	
		<!-- Botón para mostrar gráficas  -->
	<tr><td>
	<button class="btn" type="submit" onclick="pintarGraficas('{$nserie}','button',numeroVariablesGrafica,'{$sufijo}')">
			Mostrar
	</button> 
	</td></tr>
	</table>
	 
	 
	  <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	init(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
		']]></xsl:text><xsl:value-of select="$sufijo" /> <xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>
	 
   </div>	
   
   
		 
</xsl:template>	
</xsl:stylesheet>


      	
      	

