<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>	

<!--  
XSL que muestra las 4,5 y 6 primeras variables del XML, que en este caso se refieren al Vel_Viento_Min, Vel_Viento_Med 
y Vel_Viento_Max de la Vaisala. 

PARAMETROS A CONFIGURAR

1.- Variable XLS "prefijo: Cada gr�fica debe tener un sufijo distinto para diferenciar los
componentes HTML, las variables en el LocalStorage y las variables XLS
<xsl:variable name="sufijo" >
	<xsl:value-of select="'MultiLine9'"/>     f
</xsl:variable>

2.- Variables parametro1 y parametro2 seg�n los par�metros del XML que se quieran mostrar.	 

3.- Copiar el c�digo XSL y HMTL al final de este archivo seg�n el n�mero de variables.


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
<!-- plantilla para gesti�n de los datos-->
<div>

  

  	
<xsl:text disable-output-escaping="yes">
      			<![CDATA[<script src='http://code.jquery.com/jquery-1.9.1.js'> </script>]]>
      			<![CDATA[<script src='http://code.highcharts.com/highcharts.js'> </script>]]>
      			<!-- <![CDATA[<script  language="JavaScript" src='/html/portlet/xsl_content/FuncionesAuxiliares.min.js'> </script>]]>-->
      				
      			<![CDATA[
				<script> 
				
      			
				
			/*Funci�n que almacena en el localStorage los datos correspondientes a los valores de tiempo (ejeX), los datos (ejeY), la variable y unidad*/
      			
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
			
		
				
	</script>]]>      			
      		</xsl:text>


<!-- IMPORTANTE: DEBEMOS DEFINIR UN SUFIJO QUE SEA DIFERENTE EN CADA GRAFICA DE LA MISMA P�GINA.
Esto permite distinguir en el LocalStorage del navegador las variables de esta grafica con las dem�s.-->     
		
<xsl:variable name="sufijo" >
	<xsl:value-of select="'Grafica_Vaisala_Temp_Pres'"/>
</xsl:variable>	   

<xsl:variable name="parametro1" >
	<xsl:value-of select="'Temp_Aire'"/>
</xsl:variable>

 <xsl:variable name="parametro2" >
	<xsl:value-of select="'Pre_Atmosferica'"/>
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
				//Definici�n de variables globales
				
				//IMPORTANTE: CAMBIAR ESTAS VARIABLES GLOBALES
				 
				//N�mero de variables que se pueden mostrar en la gr�fica (num variables que se parsean)
				var numeroVariablesGrafica = 9;		
				
				
				
				
				
      			</script>
			]]> 
      		</xsl:text>		
      		
      		
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	
 		<script> 
 		/* Funci�n para buscar el n�mero de par�metro dado su nombre*/
 		function buscarIndexParam(param,numeroVariablesGrafica, nserie, sufijo){
	 		for	(i = 0; i < numeroVariablesGrafica; i++) {
	      		var aux = window.localStorage.getItem(nserie+"_variable_meteo"+(i+1)+"_"+sufijo)
	      		if(param  == aux){
	      			return i;
	      		}	
	      	}
 		}
 		
 		//Pasa los datos de una variable a un array
 		function obtenerDatos(indexParam,nserie,sufijo){
 			var alm_datos=nserie+"_datos_meteo"+(indexParam+1)+"_"+sufijo; //Datos para el ejeY 
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
			
			return dat;
 		}
 		
 		
 		 /* Funci�n que pinta la grafica, pasamos el valor del boton 
 		que determina la variable a pintar y el num serie del sensor */       
       
        function pintarDualAxes (valor,nserie,numeroVariablesGrafica,sufijo){
        
	        window.localStorage.removeItem(nserie+"_valor_meteo"); //Almacenamos el nuevo valor del bot�n pulsado (por si el usuario cambia la variable a mostrar)
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
	      	var param1 = ']]></xsl:text><xsl:value-of select="$parametro1" /><xsl:text disable-output-escaping="yes"><![CDATA[';
	      	var indexParam1 = buscarIndexParam(param1,numeroVariablesGrafica, nserie, sufijo);
	      	
	      	var param2 = ']]></xsl:text><xsl:value-of select="$parametro2" /><xsl:text disable-output-escaping="yes"><![CDATA[';
	      	var indexParam2 = buscarIndexParam(param2,numeroVariablesGrafica, nserie, sufijo);
	      	
	      	
	      	var dat1 = obtenerDatos(indexParam1,nserie,sufijo);
	      	var dat2 = obtenerDatos(indexParam2,nserie,sufijo);
	      	
			
			//Unidades (Para mostrar como leyenda)
			var units1=window.localStorage.getItem(nserie+"_unidad_meteo"+(indexParam1+1)+"_"+sufijo);
			var units2=window.localStorage.getItem(nserie+"_unidad_meteo"+(indexParam2+1)+"_"+sufijo);
			
			var chart = new Highcharts.Chart({
                chart: {
                renderTo: nserie + '_container_' + sufijo,
		            zoomType: 'xy'
		        },
		        title: {
		            text: ']]></xsl:text><xsl:value-of select="$Title" /> <xsl:text disable-output-escaping="yes"><![CDATA['
		        },
		        
		        xAxis: [{
		            categories: etiq,
		            crosshair: true
		        }],
		        yAxis: [{ // Primary yAxis
		            labels: {
		                format: '{value}'+ ' ' +units1,
		                style: {
		                    color: Highcharts.getOptions().colors[1]
		                }
		            },
		            title: {
		                text: param1,
		                style: {
		                    color: Highcharts.getOptions().colors[1]
		                }
		            }
		        }, { // Secondary yAxis
		            title: {
		                text: param2,
		                style: {
		                    color: Highcharts.getOptions().colors[0]
		                }
		            },
		            labels: {
		                format: '{value}'+ ' ' +units2,
		                style: {
		                    color: Highcharts.getOptions().colors[0]
		                }
		            },
		            opposite: true
		        }],
		        tooltip: {
		            shared: true
		        },				        
		        series: [{
		        
			        name: param1,
					type: 'column',
        			data : dat1,
			        yAxis: 1,
			        tooltip: {
			               valueSuffix: ' mm'
			            }
		
		        }, {
		        
		        	name: param2,
					type: 'spline',
       				data : dat2,
		            tooltip: {
		                valueSuffix: '�C'
		            }
		        }]
		      
		      
		      });
		    
		    
		    
            console.log("*** Fin Configuraci�n gr�fica HIGHCHARTS");
           
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
      			//ocultar();
	      		//if (window.localStorage.getItem(nserie+"_valor_meteo_"+sufijo)) {
	      			//alert(numeroVariablesGrafica);
	      			pintarDualAxes(1,nserie,numeroVariablesGrafica,sufijo);
	      			//pintarGraficas(nserie,"reload",numeroVariablesGrafica,sufijo);
				//}   
			
		}
		init(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
		']]></xsl:text><xsl:value-of select="$sufijo" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	 
	  
	 
   </div>	
   
   
		 
</xsl:template>	
</xsl:stylesheet>


      	
      	

