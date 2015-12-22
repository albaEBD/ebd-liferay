<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>	

	<xsl:strip-space elements="*"/>
	
	<xsl:template match="root">
	<html>
		<head>
			<xsl:text disable-output-escaping="yes">
      			<![CDATA[<script src='/html/portlet/xsl_content/Chart.min.js'> </script>]]>
      		</xsl:text>
      		

		</head> 
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
      		</xsl:text>
<xsl:text disable-output-escaping="yes">
      			<![CDATA[
				<script>
				
				window.onload = function() {
			    
			         //alert("Hello my friend. This is your first visit2.");
 			         var divs = document.getElementsByTagName("canvas"), item;
 	  				 for (var i = 0, len = divs.length; i < len; i++) {
						    item = divs[i];
						    item.style.display = "none";						    
					 }   
			    
				}
				
				//Función que almacena en el localStorage los datos correspondientes a los valores de tiempo (ejeX), los datos (ejeY), la variable y unidad
      			
      			function almacenar_MultiLine(nserie_MultiLine,posicion,etiquetas,datos,vable,unit) //Pasamos num serie del sensor(nserie_MultiLine), 
      																		   //valor del boton que gestiona la variable(posicion),
      									 									   //instantes de tiempo en que se mide(etiquetas), 
      																		   //mediciones(datos), variable a medir (vable), unidad (unit) 
      			{ 
      				console.log("IMPRIMIENDO EN CONSOLA DESDE FUNCION ALMACENAR");
      				console.log("nserie_MultiLine:"+nserie_MultiLine);
      				console.log("posicion:"+ posicion);
      				console.log("etiquetas:"+etiquetas);
      				console.log("datos:"+datos);
      				console.log("vable:"+vable);
      				console.log("unit:"+unit );
      				
      				
      				
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
       
       	console.log("*** INICIO FUNCION PINTAR");
       	console.log("llega0");
       	console.log("En la función pintar con los datos valor:"+valor+", nserie_MultiLine:"+nserie_MultiLine);
        
      	Chart.defaults.global.responsive = true; //Permite que el grafico sea responsive
      	
      	window.localStorage.removeItem(nserie_MultiLine+"_valor_meteo_MultiLine"); //Almacenamos el nuevo valor del botón pulsado (por si el usuario cambia la variable a mostrar)
      	window.localStorage.setItem(nserie_MultiLine+"_valor_meteo_MultiLine",valor);
      	
      	console.log("llega1");
      	
      	
      	      	     	
      	

		/* LEYENDA
		
		var alm_vble=nserie_MultiLine+"_variable_meteo"+valor+"_MultiLine"; //Variable seleccionada (Para mostrar como leyenda)
		var vble=window.localStorage.getItem(alm_vble);
     
       	var alm_unit=nserie_MultiLine+"_unidad_meteo"+valor+"_MultiLine"; //Unidad de la magnitud que se mide (Para mostrar como leyenda)
      	var unit=window.localStorage.getItem(alm_unit);      	
      	    	  	       	
        var pos=nserie_MultiLine+"MDat_meteo" + valor+"_MultiLine"; //Establecemos el punto de publicación de la leyenda (varibale y unidad)
      	var unid=document.getElementById(pos);
      	console.log("El valor de pos es: "+pos);
      	console.log("El valor de unid es: "+unid);
      	console.log("Etiq");
      	console.log(etiquetas);
    	unid.innerHTML = "<h3>"+vble+": </h3><h4>"+unit+"</h4>";*/
    	
    	
    	/* ETIQUETAS */
    	var alm_etiquetas=nserie_MultiLine+"_etiquetas_meteo"+valor+"_MultiLine"; //Recuperamos los datos correspondientes a la vble seleccionada
      	var etiquetas=window.localStorage.getItem(alm_etiquetas); //Tiempo para el ejeX
    	var etiq = etiquetas.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
      	
      	
      	for	(index = 0; index < etiq.length; index++) {
    		var aux = etiq[index];
    		etiq[index] = aux.substring(aux.indexOf("T")+1,aux.length-3); 
    	}
      	
      
      	console.log("llega2 VALOR: " + valor );
      	/*  DATOS */
      	
      	var numVariables = 2;
      	
      	var numVarChecked = 0;
      	
      	for	(i = 0; i < numVariables; i++) {
      		if(document.getElementById("v"+(i+1)+"_MultiLine").checked){
      			numVarChecked=numVarChecked+1;
      		}
      	}
      	console.log("NumvarChecked: " + numVarChecked);
      	
      	var datasetsGrafica = new Array(numVarChecked);
      	var cont = 0;
      	console.log("Tam datasets: " + datasetsGrafica.length);
     	
     	for	(i = 0; i < numVariables; i++) {
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
		    			dat[index] = '';
		    		}
				}//for
				
				console.log("DAT " + i);
				console.log(dat);
				
				var labelVar = "var " + i;
				
				var JSONLine = {
					label: labelVar,
                    fillColor : "rgba(172,194,132,0.4)",
                    strokeColor : "#ACC26D",
                    pointColor : "#fff",
                    pointStrokeColor : "#9DB86D",
                    data : dat, 
                }
				datasetsGrafica[cont] = JSONLine;
				console.log("DAT " + i  + " en ARRAY:" );
				console.log(datasetsGrafica[cont].data);
				cont =  cont + 1;
      		}//if
      	}
      	
         	console.log("llega6");
         	
         	console.log("ETIQUETAS: ");
         	console.log(etiq);
         	
         	console.log("DATASETS GRAFICAS: ");
         	console.log("Tam datasets: " + datasetsGrafica.length);
         	console.log(datasetsGrafica);
         	
         	var graficaDatos = { //Datos que pasamos a la función de la librería Chartjs
                labels : etiq,
                datasets : datasetsGrafica
            };
            
            console.log("llega 7");
            
            console.log("GRAFICA DATOS");
			console.log(graficaDatos);
			
			
		
			
			           
            // get line chart canvas
            var graf=nserie_MultiLine+"graficaTest"+valor+"_MultiLine";
            var grafica = document.getElementById(graf).getContext('2d');
            // draw line chart
            var myLiveChart2 = new Chart(grafica).Line(graficaDatos);
            
            
            console.log("*** FIN FUNCION PINTAR");
            console.log(document.getElementById(nserie_MultiLine+"MDat_meteo1_MultiLine").style.display);
           
         }     
         
         
         
         /* Función para pintar las gráficas
          - nserie_MultiLine: numero de serie del sensor
          - mode: distingue entre recarga del portlet y el hacer click al boton 
         */
         function pintarGraficas_MultiLine(nserie_MultiLine,mode){
         	console.log("pintarGraficas_MultiLine"); 
         	
         	var numGraficas = 2;
         	
         	var i=0;
         	for(i=1;i<numGraficas+1;i++){
         		
         		console.log("************** ************ **************** ***************");
         		console.log(i);
         		
         		/* El usuario hace click */
         		if(document.getElementById("v"+i+"_MultiLine") && document.getElementById("v"+i+"_MultiLine").checked){       
	         		console.log("opcion 1");
	         		window.localStorage.setItem(nserie_MultiLine+"MDat_meteo"+i+"_MultiLine","checked"); 
	         		document.getElementById(nserie_MultiLine+"MDat_meteo1_MultiLine").style.display = "initial";
	         		document.getElementById(nserie_MultiLine+"graficaTest1_MultiLine").style.display = "initial";
	         		pintar_MultiLine(1,nserie_MultiLine);  
	         		/* Se recarga el portlet*/       		
	         	}else{         	
	         		if(window.localStorage.getItem(nserie_MultiLine+"MDat_meteo"+i+"_MultiLine") && window.localStorage.getItem(nserie_MultiLine+"MDat_meteo"+i+"_MultiLine")=="checked" && mode == "reload"){
	         			if(document.getElementById(nserie_MultiLine+"graficaTest1_MultiLine")){
		         			console.log("opcion 2");
		         			document.getElementById(nserie_MultiLine+"MDat_meteo1_MultiLine").style.display = "initial";
		         			document.getElementById(nserie_MultiLine+"graficaTest1_MultiLine").style.display = "initial";
		         			document.getElementById("v"+i+"_MultiLine").checked=true;
		         			pintar_MultiLine(1,nserie_MultiLine);   
		         			/* Grafica no seleccionada*/    
	         			} 	
	         		}else{
	         			console.log("opcion 3.0");
	         			if(document.getElementById(nserie_MultiLine+"MDat_meteo"+i+"_MultiLine")){  
	         				console.log("opcion 3.1");
	         				window.localStorage.removeItem(nserie_MultiLine+"MDat_meteo"+i+"_MultiLine"); 
	         				window.localStorage.setItem(nserie_MultiLine+"MDat_meteo"+i+"_MultiLine","unckecked");
	         				console.log("opcion 3.2");
	         				document.getElementById(nserie_MultiLine+"MDat_meteo1_MultiLine").style.display = "none";
	         				document.getElementById(nserie_MultiLine+"graficaTest1_MultiLine").style.display = "none";
	         				console.log("opcion 3.3");
	         			}
	         			console.log("opcion 3.4");
	         		}
	         	}
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
	

		

	
	
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init_MultiLine (nserie_MultiLine){ 
      		
      		
      		if (window.localStorage.getItem(nserie_MultiLine+"_valor_meteo_MultiLine")) {
				//var valor = window.localStorage.getItem(nserie_MultiLine+"_valor_meteo_MultiLine");
				//pintar(valor,nserie_MultiLine);
				console.log("pintarGraficas_MultiLine reload");
				pintarGraficas_MultiLine(nserie_MultiLine,"reload");
			}else{
				var unid=document.getElementById(nserie_MultiLine+"MDat_meteo_MultiLine");
    			//unid.innerHTML = "<h3>Seleccione una variable a mostrar.</h3>";
			}
			
		}
		init_MultiLine(']]></xsl:text><xsl:value-of select="$nserie_MultiLine" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	
    
    <!-- Punto de publicacion para las graficas -->
 	
  <div>
  	<xsl:variable name="mycanvasHead1_MultiLine">
        <xsl:value-of select="concat($nserie_MultiLine,'MDat_meteo1_MultiLine')"/>                     
    </xsl:variable>
    <xsl:variable name="mycanvas1_MultiLine">
        <xsl:value-of select="concat($nserie_MultiLine,'graficaTest1_MultiLine')"/>                    
    </xsl:variable>
    
    
   

    
   	 
	     <div id="{$mycanvasHead1_MultiLine}" ></div>
		 <canvas id="{$mycanvas1_MultiLine}" ></canvas>	
	 
     		
	
	 	  	
	 </div>
	 
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


      	
      	

