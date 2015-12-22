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
  	<xsl:variable name="nserie_DL" >
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
      			
      			function almacenar_DL(nserie_DL,posicion,etiquetas,datos,vable,unit) //Pasamos num serie del sensor(nserie_DL), 
      																		   //valor del boton que gestiona la variable(posicion),
      									 									   //instantes de tiempo en que se mide(etiquetas), 
      																		   //mediciones(datos), variable a medir (vable), unidad (unit) 
      			{ 
      				console.log("IMPRIMIENDO EN CONSOLA DESDE FUNCION ALMACENAR");
      				console.log("nserie_DL:"+nserie_DL);
      				console.log("posicion:"+ posicion);
      				console.log("etiquetas:"+etiquetas);
      				console.log("datos:"+datos);
      				console.log("vable:"+vable);
      				console.log("unit:"+unit );
      				
      				
      				
      				window.localStorage.removeItem(nserie_DL+"_etiquetas_meteo"+posicion+"_DL"); //borra el valor antiguo del localStorage
      				window.localStorage.setItem(nserie_DL+"_etiquetas_meteo"+posicion+"_DL",etiquetas); //almacena el valor nuevo en el localStorage 
      				
      				window.localStorage.removeItem(nserie_DL+"_datos_meteo"+posicion+"_DL");
      				window.localStorage.setItem(nserie_DL+"_datos_meteo"+posicion+"_DL",datos);
      				
      				window.localStorage.removeItem(nserie_DL+"_variable_meteo"+posicion+"_DL");
      				window.localStorage.setItem(nserie_DL+"_variable_meteo"+posicion+"_DL",vable);
      				
      				window.localStorage.removeItem(nserie_DL+"_unidad_meteo"+posicion+"_DL");
      				window.localStorage.setItem(nserie_DL+"_unidad_meteo"+posicion+"_DL",unit);
				}
      			</script>
			]]> 
      		</xsl:text>		
<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	
 		<script> 
 		/* Función que pinta la grafica, pasamos el valor del boton 
 		que determina la variable a pintar y el num serie del sensor */
       function pintar_DL (valor,nserie_DL){
       
       	console.log("*** INICIO FUNCION PINTAR");
       	
       	console.log("En la función pintar con los datos valor:"+valor+", nserie_DL:"+nserie_DL);
        
      	Chart.defaults.global.responsive = true; //Permite que el grafico sea responsive
      	
      	window.localStorage.removeItem(nserie_DL+"_valor_meteo_DL"); //Almacenamos el nuevo valor del botón pulsado (por si el usuario cambia la variable a mostrar)
      	window.localStorage.setItem(nserie_DL+"_valor_meteo_DL",valor);
      	
      	
      	var alm_etiquetas=nserie_DL+"_etiquetas_meteo"+valor+"_DL"; //Recuperamos los datos correspondientes a la vble seleccionada
      	
      	var etiquetas=window.localStorage.getItem(alm_etiquetas); //Tiempo para el ejeX
      	
      	      	     	
      	var alm_datos=nserie_DL+"_datos_meteo"+valor+"_DL"; //Datos para el ejeY 
      	var datos=window.localStorage.getItem(alm_datos);

		var alm_vble=nserie_DL+"_variable_meteo"+valor+"_DL"; //Variable seleccionada (Para mostrar como leyenda)
		var vble=window.localStorage.getItem(alm_vble);
     
       	var alm_unit=nserie_DL+"_unidad_meteo"+valor+"_DL"; //Unidad de la magnitud que se mide (Para mostrar como leyenda)
      	var unit=window.localStorage.getItem(alm_unit);
      	
      	    	  	
       	var pos=nserie_DL+"MDat_meteo" + valor+"_DL"; //Establecemos el punto de publicación de la leyenda (varibale y unidad)
      	var unid=document.getElementById(pos);
      	console.log("El valor de pos es: "+pos);
      	console.log("El valor de unid es: "+unid);
      	console.log("Etiq");
      	console.log(etiquetas);
    	unid.innerHTML = "<h3>"+vble+": </h3><h4>"+unit+"</h4>";
    	
    	
    	
    	var etiq = etiquetas.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
      	var dat = datos.split(",");
      	
      	/*El fichero XML contiene 120 valores pero nosotros mostramos sólo 20 últimos. 
      	Cada actualización del portlet (cada minuto) tenemos un valor nuevo.*/
      	
      	etiq.length -= 100;
      	dat.length -= 100;
      	
      	for	(index = 0; index < dat.length; index++) {
    		if (dat[index]!="NAN") //Si el valor es NAN se interpreta como vacio y se pinta como 0
    		{
    			dat[index] = parseFloat(dat[index]);
    		}
    		else
    		{
    			dat[index] = '';
    		}
		}
      	
         	var graficaDatos = { //Datos que pasamos a la función de la librería Chartjs
                labels : etiq,
                datasets : [
                {
                    fillColor : "rgba(172,194,132,0.4)",
                    strokeColor : "#ACC26D",
                    pointColor : "#fff",
                    pointStrokeColor : "#9DB86D",
                    data : dat, 
                }
            ]
            };
           
            // get line chart canvas
            var graf=nserie_DL+"graficaTest"+valor+"_DL";
            var grafica = document.getElementById(graf).getContext('2d');
            // draw line chart
            var myLiveChart2 = new Chart(grafica).Line(graficaDatos);
            
            
            console.log("*** FIN FUNCION PINTAR");
            console.log(document.getElementById(nserie_DL+"MDat_meteo1_DL").style.display);
           
         } 
         
         /* Función para pintar las gráficas
          - nserie_DL: numero de serie del sensor
          - mode: distingue entre recarga del portlet y el hacer click al boton 
         */
         function pintarGraficas_DL(nserie_DL,mode){
         	console.log("pintarGraficas2");
         	
         	var numGraficas = 2;
         	
         	var i=0;
         	for(i=1;i<numGraficas+1;i++){
         		
         		/* El usuario hace click */
         		if(document.getElementById("v"+i+"_DL") && document.getElementById("v"+i+"_DL").checked){       
	         		console.log("opcion 1");
	         		window.localStorage.setItem(nserie_DL+"MDat_meteo"+i+"_DL","checked"); 
	         		document.getElementById(nserie_DL+"MDat_meteo"+i+"_DL").style.display = "initial";
	         		document.getElementById(nserie_DL+"graficaTest"+i+"_DL").style.display = "initial";   
	         		pintar_DL(i,nserie_DL);  
	         		/* Se recarga el portlet*/       		
	         	}else{         	
	         		if(window.localStorage.getItem(nserie_DL+"MDat_meteo"+i+"_DL") && window.localStorage.getItem(nserie_DL+"MDat_meteo"+i+"_DL")=="checked" && mode == "reload"){
	         			if(document.getElementById(nserie_DL+"graficaTest"+i+"_DL")){
		         			console.log("opcion 2");
		         			document.getElementById(nserie_DL+"MDat_meteo"+i+"_DL").style.display = "initial";
		         			document.getElementById(nserie_DL+"graficaTest"+i+"_DL").style.display = "initial";
		         			document.getElementById("v"+i+"_DL").checked=true;
		         			pintar_DL(i,nserie_DL);   
		         			/* Grafica no seleccionada*/    
	         			} 	
	         		}else{
	         			console.log("opcion 3.0");
	         			if(document.getElementById(nserie_DL+"MDat_meteo"+i+"_DL")){  
	         				console.log("opcion 3.1");
	         				window.localStorage.removeItem(nserie_DL+"MDat_meteo"+i+"_DL"); 
	         				window.localStorage.setItem(nserie_DL+"MDat_meteo"+i+"_DL","unckecked");
	         				console.log("opcion 3.2");
	         				document.getElementById(nserie_DL+"MDat_meteo"+i+"_DL").style.display = "none";
	         				document.getElementById(nserie_DL+"graficaTest"+i+"_DL").style.display = "none";
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
    
    <xsl:variable name="nserie_DL" >
			<xsl:value-of select="/csixml/head/environment/serial-no"/>
  	</xsl:variable>	
   
   
   
	<xsl:variable name="instante_DL" > <!-- Recogemos todos los valores de tiempo del XML -->
	<xsl:for-each select="r">
		<xsl:value-of select="@time"/>
		<xsl:if test="following::node()">, </xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  
	<xsl:variable name="datos1_DL" > 
	<xsl:for-each select="//v1">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v1">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble1_DL" >
  		<xsl:value-of select="//field[1]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit1_DL" >
  		<xsl:value-of select="//field[1]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_DL(']]></xsl:text><xsl:value-of select="$nserie_DL" /> <xsl:text disable-output-escaping="yes"><![CDATA[',1,
      				']]></xsl:text><xsl:value-of select="$instante_DL" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos1_DL" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble1_DL" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit1_DL" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    <xsl:variable name="datos2_DL" >
	<xsl:for-each select="r/v2">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v2">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble2_DL" >
  		<xsl:value-of select="//field[2]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit2_DL" >
  		<xsl:value-of select="//field[2]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_DL(']]></xsl:text><xsl:value-of select="$nserie_DL" /> <xsl:text disable-output-escaping="yes"><![CDATA[',2,
      				']]></xsl:text><xsl:value-of select="$instante_DL" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos2_DL" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble2_DL" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit2_DL" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
	

		

	
	
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init_DL (nserie_DL){ 
      		
      		
      		if (window.localStorage.getItem(nserie_DL+"_valor_meteo_DL")) {
				//var valor = window.localStorage.getItem(nserie_DL+"_valor_meteo_DL");
				//pintar(valor,nserie_DL);
				console.log("pintarGraficas_DL reload");
				pintarGraficas_DL(nserie_DL,"reload");
			}else{
				var unid=document.getElementById(nserie_DL+"MDat_meteo_DL");
    			//unid.innerHTML = "<h3>Seleccione una variable a mostrar.</h3>";
			}
			
		}
		init_DL(']]></xsl:text><xsl:value-of select="$nserie_DL" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	
    
    <!-- Punto de publicacion para las graficas -->
 	
  <div>
  	<xsl:variable name="mycanvasHead1_DL">
        <xsl:value-of select="concat($nserie_DL,'MDat_meteo1_DL')"/>                     
    </xsl:variable>
    <xsl:variable name="mycanvas1_DL">
        <xsl:value-of select="concat($nserie_DL,'graficaTest1_DL')"/>                    
    </xsl:variable>
    
    
    <xsl:variable name="mycanvasHead2_DL">
        <xsl:value-of select="concat($nserie_DL,'MDat_meteo2_DL')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas2_DL">
        <xsl:value-of select="concat($nserie_DL,'graficaTest2_DL')"/>                       
    </xsl:variable>

    
   	 
	     <div id="{$mycanvasHead1_DL}" ></div>
		 <canvas id="{$mycanvas1_DL}" ></canvas>	
	 
     		
	 <div id="{$mycanvasHead2_DL}" ></div>
	 <canvas id="{$mycanvas2_DL}" ></canvas>

	 	  	
	 </div>
	 
	 <table>
	<tr><td>
	<input type="checkbox" name="valor_DL" value="1" id="v1_DL">
		<xsl:value-of select="//field[1]/@name"/>
	</input>
	</td></tr>
	
	
		<tr><td>
	<input type="checkbox" name="valor_DL" value="2" id="v2_DL">
		<xsl:value-of select="//field[2]/@name"/>
	</input>
	</td></tr>
	
	
		<!-- Botón para mostrar gráficas  -->
	<tr><td>
	<button class="btn" type="submit" name="valor_DL" onclick="pintarGraficas_DL('{$nserie_DL}','button')">
			Mostrar
	</button> 
	</td></tr>
	</table>
	 
	 
   </div>			 
</xsl:template>	
</xsl:stylesheet>


      	
      	

