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
  	 <div><h1>Estacion:<xsl:value-of select="station-name"/><br/></h1></div>
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
					    
					     //SACAR CON SUBSTR EL SUFIJO
					     					     
					    if(item.id.indexOf("checkbox") > -1 &&  (item.id.substr(item.id.indexOf("checkbox")+9,item.id.length)) == sufijo){
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
			
			
		/* Función que trocea las cadenas de datos tomadas del XML y llama a almacenar() */
		function almacenarDatos(nserie,instante,datosString,nombresString,unidadesString,sufijo){
        	/*alert(instante);*/
        	
        	//Parseamos los datos y los troceamos
        	datosString = datosString.substring(0,datosString.length-1);
        	var datosVariables = datosString.split("*"); 
        	nombresString = nombresString.substring(0,nombresString.length-1);
        	var nombres = nombresString.split(",");
        	unidadesString = unidadesString.substring(0,unidadesString.length-1);
        	var unidades = unidadesString.split(",");
        	
        	//Ya podemos calcular el número de variables del XML
      		var numVariables = nombres.length;
      		
      		//Para cada Variable llamamos a almacenar
      		for	(i = 0; i < numVariables; i++) {
      		
      			//El vector valores tiene el mismo tamaño que unidades
      			var valores = new Array(datosVariables.length);  
      			
      			//Para cada variable buscamos los valores
      			for(j = 0; j < datosVariables.length; j++) {
      				
      				//Tomamos una cadena
      				var aux = datosVariables[j];
      				
      				//Quito la ultima coma
      				aux = aux.substring(0,aux.length-1);
      				
      				//Troceamos la cadena
      				var aux2 = aux.split(",");
      				
      				//Tomo el valor que interesa
      				valores[j] = aux2[i];
      			}
      			/*alert("valores size :" + valores.length);
      			alert(nserie+ "-------- " + instante+ "-------- " +valores[0] + "," +valores[1] + "," +valores[2] +"-------- " +nombres[i]+ "-------- " +unidades[i]+ "-------- " +sufijo);*/
	    		almacenar(nserie,i+1,instante,valores,nombres[i],unidades[i],sufijo);
	    		//almacenar(nserie,posicion,etiquetas,datos,vable,unit,sufijo) 
	    	}
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
	<xsl:value-of select="'GraficaHum'"/>
</xsl:variable>	      		
      		
      		
      		
 <xsl:variable name="nserie" >
	<xsl:value-of select="/csixml/head/environment/serial-no"/>
</xsl:variable>

  	
<xsl:variable name="Title" >
	<!-- <xsl:value-of select="/csixml/head/environment/table-name"/>-->
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
				var parametrosMostrados = ["airRelativeHumidity_Avg"];
				
				//Número de variables que se pueden mostrar en la gráfica (num variables que se parsean)
				var numeroVariablesGrafica = 17;		
				
				
				/*window.onload = function() {
					//alert("inicio onload HighChart 1");					 
					ocultar();
					//alert("fin onload HighChart 1");
				}*/
				
				
				/* Al inicio ocultamos la gráfica y las variables que no esten en el vector, 
					esperando que el usuario seleccione una opción*/
				function ocultar(){
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

    
    
    <!-- LOOP XSL TOMA DE DATOS-->
     <xsl:variable name="datos" > 
		<xsl:for-each select="r">
	    	<xsl:for-each select="./*">
	   			<xsl:value-of select="node()"/>,</xsl:for-each>*</xsl:for-each>
   	</xsl:variable>  
   	
   	<xsl:variable name="nombres">
	   		<xsl:for-each select="//field"><xsl:value-of select="concat(concat(./@name,'_'),./@process)"/>,</xsl:for-each>
   	</xsl:variable>
   	
   	<xsl:variable name="unidades" >
	   		<xsl:for-each select="//field"><xsl:value-of select="./@units"/>,</xsl:for-each>
   	</xsl:variable>
   	
   	 
   	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
	      	<script> 
	      		almacenarDatos(
	      		']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		']]></xsl:text><xsl:value-of select="$datos"/> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		']]></xsl:text><xsl:value-of select="$nombres"/> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		']]></xsl:text><xsl:value-of select="$unidades"/> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		']]></xsl:text><xsl:value-of select="$sufijo" /><xsl:text disable-output-escaping="yes"><![CDATA[');	      		
		 	</script> 
		]]>
	</xsl:text>
    <!-- END LOOP XSL -->
	 
	 
	 
	 
    
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
		<xsl:value-of select="concat(concat(//field[1]/@name,'_'),//field[1]/@process)"/>
	</xsl:variable>
	
	  	
	<xsl:variable name="name1_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id1_checkbox" >
		<xsl:value-of select="concat('v1_',$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[2]/@name,'_'),//field[2]/@process)"/>
	</xsl:variable>
	
	  	
	 <xsl:variable name="name2_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id2_checkbox" >
		<xsl:value-of select="concat('v2_',$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[3]/@name,'_'),//field[3]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name3_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id3_checkbox" >
		<xsl:value-of select="concat('v3_',$sufijo)"/> 
	</xsl:variable>


	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[4]/@name,'_'),//field[4]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name4_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id4_checkbox" >
		<xsl:value-of select="concat('v4_',$sufijo)"/> 
	</xsl:variable>
	
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[5]/@name,'_'),//field[5]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name5_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id5_checkbox" >
		<xsl:value-of select="concat('v5_',$sufijo)"/> 
	</xsl:variable>
	
		<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[6]/@name,'_'),//field[6]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name6_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id6_checkbox" >
		<xsl:value-of select="concat('v6_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[7]/@name,'_'),//field[7]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name7_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id7_checkbox" >
		<xsl:value-of select="concat('v7_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[8]/@name,'_'),//field[8]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name8_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id8_checkbox" >
		<xsl:value-of select="concat('v8_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[9]/@name,'_'),//field[9]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name9_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id9_checkbox" >
		<xsl:value-of select="concat('v9_',$sufijo)"/> 
	</xsl:variable>
	
		<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[10]/@name,'_'),//field[10]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name10_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id10_checkbox" >
		<xsl:value-of select="concat('v10_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[11]/@name,'_'),//field[11]/@process)"/>
	</xsl:variable>
	
	  	
	<xsl:variable name="name11_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id11_checkbox" >
		<xsl:value-of select="concat('v11_',$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[12]/@name,'_'),//field[12]/@process)"/>
	</xsl:variable>
	
	  	
	 <xsl:variable name="name12_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id12_checkbox" >
		<xsl:value-of select="concat('v12_',$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[13]/@name,'_'),//field[13]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name13_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id13_checkbox" >
		<xsl:value-of select="concat('v13_',$sufijo)"/> 
	</xsl:variable>


	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[14]/@name,'_'),//field[14]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name14_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id14_checkbox" >
		<xsl:value-of select="concat('v14_',$sufijo)"/> 
	</xsl:variable>
	
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[15]/@name,'_'),//field[15]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name15_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id15_checkbox" >
		<xsl:value-of select="concat('v15_',$sufijo)"/> 
	</xsl:variable>
	
		<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[16]/@name,'_'),//field[16]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name16_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id16_checkbox" >
		<xsl:value-of select="concat('v16_',$sufijo)"/> 
	</xsl:variable>
	
	<xsl:variable name="aux" >
		<xsl:value-of select="concat(concat(//field[17]/@name,'_'),//field[17]/@process)"/>
	</xsl:variable>	
	  	
	 <xsl:variable name="name17_checkbox" >
		<xsl:value-of select="concat(concat($aux,'_checkbox_'),$sufijo)"/>
	</xsl:variable>
	
	<xsl:variable name="id17_checkbox" >
		<xsl:value-of select="concat('v17_',$sufijo)"/> 
	</xsl:variable>
	
	
    <!-- Punto de publicacion para las graficas -->
	 <table>
	 
	 
	 
	<tr><td>
		<div id="{$name1_checkbox}">
			<input type="checkbox"  value="1" id="{$id1_checkbox}" >
				<xsl:value-of select="concat(concat(//field[1]/@name,'_'),//field[1]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name2_checkbox}">
			<input type="checkbox"  value="2" id="{$id2_checkbox}" >
				<xsl:value-of select="concat(concat(//field[2]/@name,'_'),//field[2]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name3_checkbox}">
			<input type="checkbox"  value="3" id="{$id3_checkbox}" >
				<xsl:value-of select="concat(concat(//field[3]/@name,'_'),//field[3]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name4_checkbox}">
			<input type="checkbox"  value="4" id="{$id4_checkbox}" >
				<xsl:value-of select="concat(concat(//field[4]/@name,'_'),//field[4]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name5_checkbox}">
			<input type="checkbox"  value="5" id="{$id5_checkbox}" >
				<xsl:value-of select="concat(concat(//field[5]/@name,'_'),//field[5]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name6_checkbox}">
			<input type="checkbox"  value="6" id="{$id6_checkbox}" >
				<xsl:value-of select="concat(concat(//field[6]/@name,'_'),//field[6]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name7_checkbox}">
			<input type="checkbox"  value="7" id="{$id7_checkbox}" >
				<xsl:value-of select="concat(concat(//field[7]/@name,'_'),//field[7]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name8_checkbox}">
			<input type="checkbox"  value="8" id="{$id8_checkbox}" >
				<xsl:value-of select="concat(concat(//field[8]/@name,'_'),//field[8]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name9_checkbox}">
			<input type="checkbox"  value="9" id="{$id9_checkbox}" >
				<xsl:value-of select="concat(concat(//field[9]/@name,'_'),//field[9]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name10_checkbox}">
			<input type="checkbox"  value="10" id="{$id10_checkbox}" >
				<xsl:value-of select="concat(concat(//field[10]/@name,'_'),//field[10]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name11_checkbox}">
			<input type="checkbox"  value="11" id="{$id11_checkbox}" >
				<xsl:value-of select="concat(concat(//field[11]/@name,'_'),//field[11]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name12_checkbox}">
			<input type="checkbox"  value="12" id="{$id12_checkbox}" >
				<xsl:value-of select="concat(concat(//field[12]/@name,'_'),//field[12]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name13_checkbox}">
			<input type="checkbox"  value="13" id="{$id13_checkbox}" >
				<xsl:value-of select="concat(concat(//field[13]/@name,'_'),//field[13]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name14_checkbox}">
			<input type="checkbox"  value="14" id="{$id14_checkbox}" >
				<xsl:value-of select="concat(concat(//field[14]/@name,'_'),//field[14]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name15_checkbox}">
			<input type="checkbox"  value="15" id="{$id15_checkbox}" >
				<xsl:value-of select="concat(concat(//field[15]/@name,'_'),//field[15]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name16_checkbox}">
			<input type="checkbox"  value="16" id="{$id16_checkbox}" >
				<xsl:value-of select="concat(concat(//field[16]/@name,'_'),//field[16]/@process)"/>
			</input>
		</div>
	</td></tr>
	
	<tr><td>
		<div id="{$name17_checkbox}">
			<input type="checkbox"  value="17" id="{$id17_checkbox}" >
				<xsl:value-of select="concat(concat(//field[17]/@name,'_'),//field[17]/@process)"/>
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


      	
      	

