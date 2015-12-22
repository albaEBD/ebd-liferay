<?xml version="1.0" encoding="iso-8859-1"?>


<!--  
XSL que muestra as 3 primeras variables del XML, que en este caso se refieren al Dir_Viento_Min, Dir_Viento_Med 
y Dir_Viento_Max de la Vaisala. 
 -->


<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>	

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
  	 <div><h1>Estacion: <xsl:value-of select="station-name"/><br/></h1></div>
  	<xsl:variable name="nserie_MultiLine" >
			<xsl:value-of select="serial-no"/>
  	</xsl:variable>	
  	  
 </xsl:template>
 
 
<xsl:template match="data">
<!-- plantilla para gestión de los datos-->
<div>

   

  	
<xsl:text disable-output-escaping="yes">
      			<![CDATA[<script src='/html/portlet/xsl_content/Chart.min.js'> </script>]]>
      			<![CDATA[<script src='http://code.jquery.com/jquery-1.9.1.js'> </script>]]>
      			<![CDATA[<script src='http://code.highcharts.com/highcharts.js'> </script>]]>
      		</xsl:text>
      		
      		
      		
<xsl:variable name="nserie_MultiLine" >
	<xsl:value-of select="/csixml/head/environment/serial-no"/>
</xsl:variable>
  	
<xsl:variable name="Title_MultiLine" >
	<xsl:value-of select="/csixml/head/environment/table-name"/>
</xsl:variable>  	
  	
  	
 <xsl:variable name="container_MultiLine" >
	<xsl:value-of select="concat($nserie_MultiLine,'_container_MultiLine')"/>
</xsl:variable>	  
      		
      		
<div id="{$container_MultiLine}" style="min-width: 400px; height: 400px; margin: 0 auto"></div> 
      		
      		
<xsl:text disable-output-escaping="yes">
      			<![CDATA[
				<script> 
				
				var numeroVariablesGrafica = 3;
				
				
				/* Al inicio ocultamos la gráfica, esperando que el usuario seleccione una opción*/
				window.onload = function() {
					document.getElementById("]]></xsl:text><xsl:value-of select="$container_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[").style.display = "none";					 	
				}
				
				//Función que almacena en el localStorage los datos correspondientes a los valores de tiempo (ejeX), los datos (ejeY), la variable y unidad
      			
      			function almacenar_MultiLine(nserie_MultiLine,posicion,etiquetas,datos,vable,unit) //Pasamos num serie del sensor(nserie_MultiLine), 
      																		   //valor del boton que gestiona la variable(posicion),
      									 									   //instantes de tiempo en que se mide(etiquetas), 
      																		   //mediciones(datos), variable a medir (vable), unidad (unit) 
      			{ 
      				window.localStorage.removeItem(nserie_MultiLine+"_etiquetas_meteo"+posicion+"_MultiLine"); //borra el valor antiguo del localStorage
      				window.localStorage.setItem(nserie_MultiLine+"_etiquetas_meteo"+posicion+"_MultiLine",etiquetas); //almacena el valor nuevo en el localStorage 
      				
      				window.localStorage.removeItem(nserie_MultiLine+"_datos_meteo"+posicion+"_MultiLine");
      				window.localStorage.setItem(nserie_MultiLine+"_datos_meteo"+posicion+"_MultiLine",datos);
      				
      				window.localStorage.removeItem(nserie_MultiLine+"_variable_meteo"+posicion+"_MultiLine");
      				window.localStorage.setItem(nserie_MultiLine+"_variable_meteo"+posicion+"_MultiLine",vable);
      				
      				window.localStorage.removeItem(nserie_MultiLine+"_unidad_meteo"+posicion+"_MultiLine");
      				window.localStorage.setItem(nserie_MultiLine+"_unidad_meteo"+posicion+"_MultiLine",unit);
				}
      			</script>
			]]> 
      		</xsl:text>		
<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	
 		<script> 
 		/* Función que pinta la grafica, pasamos el valor del boton 
 		que determina la variable a pintar y el num serie del sensor */
       
        function pintar_MultiLine (valor,nserie_MultiLine){
       
       	window.localStorage.removeItem(nserie_MultiLine+"_valor_meteo_MultiLine"); //Almacenamos el nuevo valor del botón pulsado (por si el usuario cambia la variable a mostrar)
      	window.localStorage.setItem(nserie_MultiLine+"_valor_meteo_MultiLine",valor);
      	
      	/* ETIQUETAS */
    	var alm_etiquetas=nserie_MultiLine+"_etiquetas_meteo"+valor+"_MultiLine"; //Recuperamos los datos correspondientes a la vble seleccionada
      	var etiquetas=window.localStorage.getItem(alm_etiquetas); //Tiempo para el ejeX
    	var etiq = etiquetas.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
      	
      	for	(index = 0; index < etiq.length; index++) {
    		var aux = etiq[index];
    		etiq[index] = aux.substring(aux.indexOf("T")+1,aux.length-3); 
    	}
      	
      	/*  DATOS */
      	
      	/*var numVariables = 2;*/
      	var numVarChecked = 0;
      	
      	for	(i = 0; i < numeroVariablesGrafica; i++) {
      		if(document.getElementById("v"+(i+1)+"_MultiLine").checked){
      			numVarChecked=numVarChecked+1;
      		}
      	}
      	
      	var datasetsGrafica = new Array(numVarChecked);
      	var cont = 0;
      	console.log("Tam datasets: " + datasetsGrafica.length);
     	
     	for	(i = 0; i < numeroVariablesGrafica; i++) {
      		console.log("llega4");
      		if(document.getElementById("v"+(i+1)+"_MultiLine").checked){
      			
      			console.log("llega5");
      			var alm_datos=nserie_MultiLine+"_datos_meteo"+(i+1)+"_MultiLine"; //Datos para el ejeY 
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
				var labelVar=window.localStorage.getItem(nserie_MultiLine+"_variable_meteo"+(i+1)+"_MultiLine");
				
				//Unidades (Para mostrar como leyenda)
				var units=window.localStorage.getItem(nserie_MultiLine+"_unidad_meteo"+(i+1)+"_MultiLine");
				
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
				        renderTo: nserie_MultiLine + '_container_MultiLine'
				    },
				    title: {
			            text: ']]></xsl:text><xsl:value-of select="$Title_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
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
         
         
         
         /* Función para pintar las gráficas
          - nserie_MultiLine: numero de serie del sensor
          - mode: distingue entre recarga del portlet y el hacer click al boton 
         */
        
         function pintarGraficas_MultiLine(nserie_MultiLine,mode){
         	
         	/*var numGraficas = 2;*/
         	
         	var i=0;
         	for(i=1;i<numeroVariablesGrafica+1;i++){
         		
         		/* El usuario hace click */
         		if(document.getElementById("v"+i+"_MultiLine") && document.getElementById("v"+i+"_MultiLine").checked){       
	         		console.log("opcion 1 con i " + i);
	         		window.localStorage.setItem(nserie_MultiLine+"_container_"+i+"_MultiLine","checked"); 
	         		document.getElementById(nserie_MultiLine+"_container_MultiLine").style.display = "";
	         		pintar_MultiLine(1,nserie_MultiLine);  
	         		
	         		
	         		
	         	/* Se recarga la gráfica (reload) con opciones checkeadas*/       		
	         	}else{         	
	         		if(window.localStorage.getItem(nserie_MultiLine+"_container_"+i+"_MultiLine") && window.localStorage.getItem(nserie_MultiLine+"_container_"+i+"_MultiLine")=="checked" && mode == "reload"){
	         			if(document.getElementById(nserie_MultiLine+"_container_MultiLine")){
		         			console.log("opcion 2 con i " + i);
		         			document.getElementById(nserie_MultiLine+"_container_MultiLine").style.display = "";
		         			document.getElementById("v"+i+"_MultiLine").checked=true;
		         			pintar_MultiLine(1,nserie_MultiLine);   
		         			/* Grafica no seleccionada*/    
	         			} 	
	         			
	         			
	         		}else{ /*Ninguna opcion checkeada*/
	         			console.log("opcion 3.0 con i " + i);
	         			if(document.getElementById(nserie_MultiLine+"_container_MultiLine")){   
	         				window.localStorage.removeItem(nserie_MultiLine+"_container_"+i+"_MultiLine"); 
	         				window.localStorage.setItem(nserie_MultiLine+"_container_"+i+"_MultiLine","unchecked");
	         				//document.getElementById(nserie_MultiLine+"_container_MultiLine").style.display = "none";	         				
	         			}
	         		}
	         	}
         	}
         	
         	//Si todos estan unchecked se oculta la grafica
         	var ocultar = 1;
         	for(i=1;i<numeroVariablesGrafica+1;i++){
         	 	if(window.localStorage.getItem(nserie_MultiLine+"_container_"+i+"_MultiLine")=="checked"){
         	 		ocultar=0;         	 	
         		}
         	}
         	if(ocultar==1){
         		document.getElementById(nserie_MultiLine+"_container_MultiLine").style.display = "none";   
         	}
         	
         	
         }
         
         
         
            
</script> 
]]> 
    </xsl:text>	
    
    <xsl:variable name="nserie_MultiLine" >
			<xsl:value-of select="/csixml/head/environment/serial-no"/>
  	</xsl:variable>	
   
   
   
	<xsl:variable name="instante_MultiLine" > <!-- Recogemos todos los valores de tiempo del XML -->
	<xsl:for-each select="r">
		<xsl:value-of select="@time"/>
		<xsl:if test="following::node()">, </xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  
	<xsl:variable name="datos1_MultiLine" > 
	<xsl:for-each select="//v1">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v1">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble1_MultiLine" >
  		<xsl:value-of select="//field[1]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit1_MultiLine" >
  		<xsl:value-of select="//field[1]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_MultiLine(']]></xsl:text><xsl:value-of select="$nserie_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',1,
      				']]></xsl:text><xsl:value-of select="$instante_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos1_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble1_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit1_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    <xsl:variable name="datos2_MultiLine" >
	<xsl:for-each select="r/v2">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v2">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble2_MultiLine" >
  		<xsl:value-of select="//field[2]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit2_MultiLine" >
  		<xsl:value-of select="//field[2]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_MultiLine(']]></xsl:text><xsl:value-of select="$nserie_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',2,
      				']]></xsl:text><xsl:value-of select="$instante_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos2_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble2_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit2_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    
    <xsl:variable name="datos3_MultiLine" > 
	<xsl:for-each select="//v3">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v3">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble3_MultiLine" >
  		<xsl:value-of select="//field[3]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit3_MultiLine" >
  		<xsl:value-of select="//field[3]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_MultiLine(']]></xsl:text><xsl:value-of select="$nserie_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',3,
      				']]></xsl:text><xsl:value-of select="$instante_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos3_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble3_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit3_MultiLine" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>
    
    
	
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init_MultiLine (nserie_MultiLine){ 
      		
      		
      		if (window.localStorage.getItem(nserie_MultiLine+"_valor_meteo_MultiLine")) {
				pintarGraficas_MultiLine(nserie_MultiLine,"reload");
			}else{
				var unid=document.getElementById(nserie_MultiLine+"_container_MultiLine");
			}
			
		}
		init_MultiLine(']]></xsl:text><xsl:value-of select="$nserie_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	
    
    <!-- Punto de publicacion para las graficas -->
	 
	 <table>
	<tr><td>
	<input type="checkbox" name="valor_MultiLine" value="1" id="v1_MultiLine">
		<xsl:value-of select="//field[1]/@name"/>
	</input>
	</td></tr>
	
	
	<tr><td>
	<input type="checkbox" name="valor_MultiLine" value="2" id="v2_MultiLine">
		<xsl:value-of select="//field[2]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_MultiLine" value="3" id="v3_MultiLine">
		<xsl:value-of select="//field[3]/@name"/>
	</input>
	</td></tr>
	
	
		<!-- Botón para mostrar gráficas  -->
	<tr><td>
	<button class="btn" type="submit" name="valor_MultiLine" onclick="pintarGraficas_MultiLine('{$nserie_MultiLine}','button')">
			Mostrar
	</button> 
	</td></tr>
	</table>
	 
	 
   </div>			 
</xsl:template>	
</xsl:stylesheet>


      	
      	

