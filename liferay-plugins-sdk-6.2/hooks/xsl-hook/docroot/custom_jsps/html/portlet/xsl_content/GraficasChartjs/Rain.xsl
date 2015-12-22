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
  	<xsl:variable name="nserie" >
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
      			
      			function almacenar(nserie,posicion,etiquetas,datos,vable,unit) //Pasamos num serie del sensor(nserie), 
      																		   //valor del boton que gestiona la variable(posicion),
      																		   //instantes de tiempo en que se mide(etiquetas), 
      																		   //mediciones(datos), variable a medir (vable), unidad (unit) 
      			{ 
      				console.log("IMPRIMIENDO EN CONSOLA DESDE FUNCION ALMACENAR");
      				console.log("nserie:"+nserie+", posicion:"+ posicion+", etiquetas:"+etiquetas+", datos:"+datos+", vable:"+vable+", unit:"+unit );
      				console.log("llega1");
      				
      				
      				window.localStorage.removeItem(nserie+"_etiquetas_meteo"+posicion); //borra el valor antiguo del localStorage
      				window.localStorage.setItem(nserie+"_etiquetas_meteo"+posicion,etiquetas); //almacena el valor nuevo en el localStorage 
      				
      				window.localStorage.removeItem(nserie+"_datos_meteo"+posicion);
      				window.localStorage.setItem(nserie+"_datos_meteo"+posicion,datos);
      				
      				window.localStorage.removeItem(nserie+"_variable_meteo"+posicion);
      				window.localStorage.setItem(nserie+"_variable_meteo"+posicion,vable);
      				
      				window.localStorage.removeItem(nserie+"_unidad_meteo"+posicion);
      				window.localStorage.setItem(nserie+"_unidad_meteo"+posicion,unit);
				}
      			</script>
			]]> 
      		</xsl:text>		
<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	
 		<script> 
 		/* Función que pinta la grafica, pasamos el valor del boton que determina la variable a pintar y el num serie del sensor */
       function pintar (valor,nserie){
       
       	console.log("*** INICIO FUNCION PINTAR");
       	
       	console.log("En la función pintar con los datos valor:"+valor+", nserie:"+nserie);
        
      	Chart.defaults.global.responsive = true; //Permite que el grafico sea responsive
      	
      	window.localStorage.removeItem(nserie+"_valor_meteo"); //Almacenamos el nuevo valor del botón pulsado (por si el usuario cambia la variable a mostrar)
      	window.localStorage.setItem(nserie+"_valor_meteo",valor);
      	
      	
      	var alm_etiquetas=nserie+"_etiquetas_meteo"+valor; //Recuperamos los datos correspondientes a la vble seleccionada
      	
      	var etiquetas=window.localStorage.getItem(alm_etiquetas); //Tiempo para el ejeX
      	
      	      	     	
      	var alm_datos=nserie+"_datos_meteo"+valor; //Datos para el ejeY
      	var datos=window.localStorage.getItem(alm_datos);

		var alm_vble=nserie+"_variable_meteo"+valor; //Variable seleccionada (Para mostrar como leyenda)
		var vble=window.localStorage.getItem(alm_vble);
     
       	var alm_unit=nserie+"_unidad_meteo"+valor; //Unidad de la magnitud que se mide (Para mostrar como leyenda)
      	var unit=window.localStorage.getItem(alm_unit);
      	
      	    	  	
       	var pos=nserie+"MDat_meteo" + valor; //Establecemos el punto de publicación de la leyenda (varibale y unidad)
      	var unid=document.getElementById(pos);
      	console.log("El valor de pos es: "+pos);
      	console.log("El valor de unid es: "+unid);
    	unid.innerHTML = "<h3>"+vble+": </h3><h4>"+unit+"</h4>";
    	
    
    	
    	var etiq = etiquetas.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
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
            var graf=nserie+"graficaTest"+valor;
            var grafica = document.getElementById(graf).getContext('2d');
            // draw line chart
            var myLiveChart2 = new Chart(grafica).Line(graficaDatos);
            
            
            console.log("*** FIN FUNCION PINTAR");
            console.log(document.getElementById(nserie+"MDat_meteo1").style.display);
           
         } 
         
         /* Función para pintar las gráficas
          - nserie: numero de serie del sensor
          - mode: distingue entre recarga del portlet y el hacer click al boton 
         */
         function pintarGraficas(nserie,mode){
         	console.log("pintarGraficas2");
         	
         	var numGraficas = 1;
         	
         	var i=0;
         	for(i=1;i<numGraficas+1;i++){
         		
         		/* El usuario hace click */
         		if(document.getElementById("v"+i) && document.getElementById("v"+i).checked){       
	         		console.log("opcion 1");
	         		window.localStorage.setItem(nserie+"MDat_meteo"+i,"checked"); 
	         		document.getElementById(nserie+"MDat_meteo"+i).style.display = "initial";
	         		document.getElementById(nserie+"graficaTest"+i).style.display = "initial";   
	         		pintar(i,nserie);  
	         		/* Se recarga el portlet*/       		
	         	}else{         	
	         		if(window.localStorage.getItem(nserie+"MDat_meteo"+i) && window.localStorage.getItem(nserie+"MDat_meteo"+i)=="checked" && mode == "reload"){
	         			if(document.getElementById(nserie+"graficaTest"+i)){
		         			console.log("opcion 2");
		         			document.getElementById(nserie+"MDat_meteo"+i).style.display = "initial";
		         			document.getElementById(nserie+"graficaTest"+i).style.display = "initial";
		         			document.getElementById("v"+i).checked=true;
		         			pintar(i,nserie);   
		         			/* Grafica no seleccionada*/    
	         			} 	
	         		}else{
	         			console.log("opcion 3.0");
	         			if(document.getElementById(nserie+"MDat_meteo"+i)){  
	         				console.log("opcion 3.1");
	         				window.localStorage.removeItem(nserie+"MDat_meteo"+i); 
	         				window.localStorage.setItem(nserie+"MDat_meteo"+i,"unckecked");
	         				console.log("opcion 3.2");
	         				document.getElementById(nserie+"MDat_meteo"+i).style.display = "none";
	         				document.getElementById(nserie+"graficaTest"+i).style.display = "none";
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
	 <!-- <button class="btn" type="submit" name="valor" value="1" onclick="pintar(1,'{$nserie}')">
			<xsl:value-of select="//field[1]/@name"/>
	</button>-->
	
	<table>
	<tr><td>
	<input type="checkbox" name="valor" value="1" id="v1">
		<xsl:value-of select="//field[1]/@name"/>
	</input>
	</td></tr>
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[',1,
      				']]></xsl:text><xsl:value-of select="$instante" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos1" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble1" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit1" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    

		
	<!-- Botón para mostrar gráficas  -->
	<tr><td>
	<button class="btn" type="submit" name="valor" onclick="pintarGraficas('{$nserie}','button')">
			Mostrar
	</button> 
	</td></tr>
	</table>
	
	
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init (nserie){ 
      		
      		console.log("Llega a INIT!");
      		
      		
      		
      		if (window.localStorage.getItem(nserie+"_valor_meteo")) {
				//var valor = window.localStorage.getItem(nserie+"_valor_meteo");
				//pintar(valor,nserie);
				console.log("pintarGraficas reload");
				pintarGraficas(nserie,"reload");
			}else{
				var unid=document.getElementById(nserie+"MDat_meteo");
    			//unid.innerHTML = "<h3>Seleccione una variable a mostrar.</h3>";
			}
			
		}
		init(']]></xsl:text><xsl:value-of select="$nserie" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	
    
    <!-- Punto de publicacion para las graficas -->
 	
  <div>
  	<xsl:variable name="mycanvasHead1">
        <xsl:value-of select="concat($nserie,'MDat_meteo1')"/>                     
    </xsl:variable>
    <xsl:variable name="mycanvas1">
        <xsl:value-of select="concat($nserie,'graficaTest1')"/>                    
    </xsl:variable>
    
    

    
   	 
	     <div id="{$mycanvasHead1}" ></div>
		 <canvas id="{$mycanvas1}" ></canvas>	
	 	  	
	 </div>
   </div>			 
</xsl:template>	
</xsl:stylesheet>


      	
      	

