<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>	

<!--  
PARAMETROS A CONFIGURAR
    
Array con parámetros seleccionados para mostrar en la gráfica
var parametrosMostrados 
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
<div id="principal">
  	
<xsl:text disable-output-escaping="yes">
      			<![CDATA[<script src='http://code.jquery.com/jquery-1.9.1.js'> </script>]]>
      			<![CDATA[<script src='http://code.highcharts.com/highcharts.js'> </script>]]>
      			
      			<!-- <![CDATA[<script  language="JavaScript" src='/html/portlet/xsl_content/FuncionesAuxiliares.min.js'> </script>]]>-->
      				
      			<![CDATA[
				<script> 
				
				//alert(document.getElementById("principal").parentNode.parentNode.parentNode.parentNode.id);
				
				/* Tomamos el id del portlet como sufijo*/
      			var sufijo = document.getElementById("principal").parentNode.parentNode.parentNode.parentNode.id;   
      			//alert("sufijo " + sufijo);
      			
      			
      			var auxSufijos = window.localStorage.getItem("sufijos");
      			
      			//alert("auxSufijos"  +  auxSufijos);
      			
      			if(auxSufijos == null){
      				//alert(auxSufijos);
      				window.localStorage.setItem("sufijos",sufijo); 
      			}else{
      				if(auxSufijos.indexOf(sufijo) == -1){
	      				//alert(auxSufijos+","+sufijo);
	      				window.localStorage.removeItem("sufijos");
	      				window.localStorage.setItem("sufijos",auxSufijos+","+sufijo);
      				}
      			}
      			
      			document.getElementById("principal").id=""+sufijo;
      			
				
				/*
				 * Función para ocultar los objectos div cuyo id sea container 
				 * (son div que contienen las gráficas)
				 */
				function ocultarContainer(sufijo){ 
				
					var divs = document.getElementsByTagName("div"), item;
					
					for (var i = 0, len = divs.length; i < len; i++) {
					 		
					 		//Ocultamos la grafica
					 		item = divs[i];
					 			
					 		if(item.id.indexOf("container") > -1 && item.id.substr(item.id.indexOf("portlet"),item.id.length) == sufijo){
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
					    
					    
					    
					    if(item.id.indexOf("checkbox") > -1 && item.id.substr(item.id.indexOf("portlet"),item.id.length) == sufijo){
					    
					    
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
		function almacenarDatos(nserie,instante,datosString,nombresProcessString,unidadesString,sufijo){
        	
        	
        	//Parseamos los datos y los troceamos
        	datosString = datosString.substring(0,datosString.length-1);
        	var datosVariables = datosString.split("*"); 
        	nombresProcessString = nombresProcessString.substring(0,nombresProcessString.length-1);
        	var nombresProcess = nombresProcessString.split(",");
        	unidadesString = unidadesString.substring(0,unidadesString.length-1);
        	var unidades = unidadesString.split(",");
        	
        	//Ya podemos calcular el número de variables del XML
        	numeroVariablesGrafica = nombresProcess.length;
      		
      		//Para cada Variable llamamos a almacenar
      		for	(i = 0; i < numeroVariablesGrafica; i++) {
      		
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
      			alert(nserie+ "-------- " + instante+ "-------- " +valores[0] + "," +valores[1] + "," +valores[2] +"-------- " +nombresProcess[i]+ "-------- " +unidades[i]+ "-------- " +sufijo);*/
	    		almacenar(nserie,(i+1),instante,valores,nombresProcess[i],unidades[i],sufijo);
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
         
            //alert(sufijo);
         	
         	
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
		         			if(document.getElementById("v"+i+"_"+sufijo)){
		         				document.getElementById("v"+i+"_"+sufijo).checked=true;
		         				//alert("3 opcion 2 con i " + i);
		         				pintar(1,nserie,numeroVariablesGrafica,sufijo);
		         			}   
		         			  
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
<!-- <xsl:variable name="sufijo" >
	<xsl:value-of select="'Grafica'"/>
</xsl:variable>-->	      		
      		
      		
      		
 <xsl:variable name="nserie" >
	<xsl:value-of select="/csixml/head/environment/serial-no"/>
</xsl:variable>

  	
<xsl:variable name="Title" >
	<!-- <xsl:value-of select="/csixml/head/environment/table-name"/>-->
	 <xsl:value-of select="/csixml/head/environment/table-name"/>
</xsl:variable>  	
  	
  	
 <!-- 
 <xsl:variable name="container" >
	<xsl:value-of select="concat(concat($nserie,'_container_'),$sufijo)"/>
</xsl:variable>	  

      		
      		
<div id="{$container}" name="{$container}" style="min-width: 400px; height: 400px; margin: 0 auto"></div>-->

 <!-- Punto de publicacion para los checkboxs -->

<div id="grafica" ></div>

  <xsl:text disable-output-escaping="yes">
   		<![CDATA[ 
    	<script> 
    	   var div = document.getElementById("grafica");
    	   div.id = "grafica_" + sufijo;   
    	
    	   var nserie = ']]></xsl:text><xsl:value-of select="$nserie"/> <xsl:text disable-output-escaping="yes"><![CDATA[';
    	   var idDiv = nserie+"_container_"+sufijo;
    	   document.getElementById("grafica_"+sufijo).innerHTML = "<div id='"+idDiv+ "' name='"+ idDiv +"' style='min-width: 400px; height: 400px; margin: 0 auto'></div> ";
    	   
    	</script> 
		]]>
  </xsl:text>	
      		
      		
<xsl:text disable-output-escaping="yes">
      			<![CDATA[
				<script> 
				//Definición de variables globales
				
				//IMPORTANTE: CAMBIAR ESTAS DOS VARIABLES GLOBALES
				
				//Parámetros seleccionados para mostrar en la gráfica
				var parametrosMostrados = ["windDirection_Avg","windDirection_Max","windDirection_Min"];
				
				//Número de variables que se pueden mostrar en la gráfica (num variables que se parsean)
				var numeroVariablesGrafica;		
				
				
				/* Al inicio ocultamos la gráfica y las variables que no esten en el vector, 
					esperando que el usuario seleccione una opción*/  
				function ocultar(suf){
						ocultarContainer(suf);
						ocultarCheckboxs(parametrosMostrados,suf);						
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
   	
   	<xsl:variable name="nombresProcess">
	   		<xsl:for-each select="//field"><xsl:value-of select="concat(concat(./@name,'_'),./@process)"/>,</xsl:for-each>
   	</xsl:variable>
   	
   	<xsl:variable name="nombres">
	   		<xsl:for-each select="//field"><xsl:value-of select="./@name"/>,</xsl:for-each>
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
	      		']]></xsl:text><xsl:value-of select="$nombresProcess"/> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		']]></xsl:text><xsl:value-of select="$unidades"/> <xsl:text disable-output-escaping="yes"><![CDATA[',
	      		sufijo);	      		
		 	</script> 
		]]>
	</xsl:text>
    <!-- END LOOP XSL -->
	 
	 
	 
	 
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init (nserie,sufijo){ 
      			
      			/*var sufs = window.localStorage.getItem("sufijos");
      			
      			var sufsArray = sufs.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
      	
      			for	(index = 0; index < sufsArray.length; index++) {
      				var suf = sufsArray[index];*/
      			
	      			ocultar(sufijo);
		      		if (window.localStorage.getItem(nserie+"_valor_meteo_"+sufijo)) {
		      			//alert("pintarGraficas " +  sufijo);
		      			pintarGraficas(nserie,"reload",numeroVariablesGrafica,sufijo);
					}
				/*}*/
			
		}
		

		
</script> 
]]>
    </xsl:text>	

<!-- Punto de publicacion para los checkboxs -->
	 
	 	<div id="options" ></div>
	 
	    <xsl:text disable-output-escaping="yes">
      		<![CDATA[ 
	      	<script> 
	      	   var div = document.getElementById("options");
	      	
	      	   var nombres = ']]></xsl:text><xsl:value-of select="$nombres"/> <xsl:text disable-output-escaping="yes"><![CDATA[';
	      	   var nombresProcess = ']]></xsl:text><xsl:value-of select="$nombresProcess"/> <xsl:text disable-output-escaping="yes"><![CDATA[';
	      	   nombresProcess = nombresProcess.substring(0,nombresProcess.length-1);
	      	   var aux = nombresProcess.split(",");
	      	   
	      	   //Cambiamos el nombre al div para diferenciarlo
	      	   div.id= "options_" + sufijo;
	      	   
	      	   var cadena = "";
	      	   
	      	   for	(i = 0; i < aux.length; i++) {
	      	   		var idDiv = aux[i]+"_checkbox_"+sufijo;
	      	   		var idCheckbox = "v"+(i+1)+"_"+sufijo;
	      	   		
	      	   		cadena = cadena + "<div id='"+idDiv+"'>" + 
				      	   		           "<input type='checkbox'  value='"+(i+1)+"' id='"+idCheckbox+"'>" + 
				      	   		           		aux[i] +
				      	   		           "</input>" + 
				      	   		   "</div>";
	      	   }
	      	   document.getElementById("options_" + sufijo).innerHTML = cadena;
	      	   
			</script> 
			]]>
	    </xsl:text>	
	
    
	 
	  <!-- Botón para mostrar gráficas  -->
	<div>
	<button class="btn" type="submit" onclick="pintarGraficas('{$nserie}','button',numeroVariablesGrafica,this.parentNode.parentNode.id)">
			Mostrar
	</button>
	
	
	
	 
	</div>
	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	init(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',sufijo);
 	</script> 
	]]>
    </xsl:text>
	 
   </div>	
   
   
		 
</xsl:template>	
</xsl:stylesheet>