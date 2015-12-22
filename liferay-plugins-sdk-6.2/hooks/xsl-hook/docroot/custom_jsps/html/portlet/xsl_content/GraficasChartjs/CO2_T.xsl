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
  	<xsl:variable name="nserie_CO2_T" >
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
      			
      			function almacenar_CO2_T(nserie_CO2_T,posicion,etiquetas,datos,vable,unit) //Pasamos num serie del sensor(nserie_CO2_T), 
      																		   //valor del boton que gestiona la variable(posicion),
      									 									   //instantes de tiempo en que se mide(etiquetas), 
      																		   //mediciones(datos), variable a medir (vable), unidad (unit) 
      			{ 
      				console.log("IMPRIMIENDO EN CONSOLA DESDE FUNCION ALMACENAR");
      				console.log("nserie_CO2_T:"+nserie_CO2_T);
      				console.log("posicion:"+ posicion);
      				console.log("etiquetas:"+etiquetas);
      				console.log("datos:"+datos);
      				console.log("vable:"+vable);
      				console.log("unit:"+unit );
      				
      				
      				
      				window.localStorage.removeItem(nserie_CO2_T+"_etiquetas_meteo"+posicion+"_CO2_T"); //borra el valor antiguo del localStorage
      				window.localStorage.setItem(nserie_CO2_T+"_etiquetas_meteo"+posicion+"_CO2_T",etiquetas); //almacena el valor nuevo en el localStorage 
      				
      				window.localStorage.removeItem(nserie_CO2_T+"_datos_meteo"+posicion+"_CO2_T");
      				window.localStorage.setItem(nserie_CO2_T+"_datos_meteo"+posicion+"_CO2_T",datos);
      				
      				window.localStorage.removeItem(nserie_CO2_T+"_variable_meteo"+posicion+"_CO2_T");
      				window.localStorage.setItem(nserie_CO2_T+"_variable_meteo"+posicion+"_CO2_T",vable);
      				
      				window.localStorage.removeItem(nserie_CO2_T+"_unidad_meteo"+posicion+"_CO2_T");
      				window.localStorage.setItem(nserie_CO2_T+"_unidad_meteo"+posicion+"_CO2_T",unit);
				}
      			</script>
			]]> 
      		</xsl:text>		
<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	
 		<script> 
 		/* Función que pinta la grafica, pasamos el valor del boton 
 		que determina la variable a pintar y el num serie del sensor */
       function pintar_CO2_T (valor,nserie_CO2_T){
       
       	console.log("*** INICIO FUNCION PINTAR");
       	
       	console.log("En la función pintar con los datos valor:"+valor+", nserie_CO2_T:"+nserie_CO2_T);
        
      	Chart.defaults.global.responsive = true; //Permite que el grafico sea responsive
      	
      	window.localStorage.removeItem(nserie_CO2_T+"_valor_meteo_CO2_T"); //Almacenamos el nuevo valor del botón pulsado (por si el usuario cambia la variable a mostrar)
      	window.localStorage.setItem(nserie_CO2_T+"_valor_meteo_CO2_T",valor);
      	
      	
      	var alm_etiquetas=nserie_CO2_T+"_etiquetas_meteo"+valor+"_CO2_T"; //Recuperamos los datos correspondientes a la vble seleccionada
      	
      	var etiquetas=window.localStorage.getItem(alm_etiquetas); //Tiempo para el ejeX
      	
      	      	     	
      	var alm_datos=nserie_CO2_T+"_datos_meteo"+valor+"_CO2_T"; //Datos para el ejeY 
      	var datos=window.localStorage.getItem(alm_datos);

		var alm_vble=nserie_CO2_T+"_variable_meteo"+valor+"_CO2_T"; //Variable seleccionada (Para mostrar como leyenda)
		var vble=window.localStorage.getItem(alm_vble);
     
       	var alm_unit=nserie_CO2_T+"_unidad_meteo"+valor+"_CO2_T"; //Unidad de la magnitud que se mide (Para mostrar como leyenda)
      	var unit=window.localStorage.getItem(alm_unit);
      	
      	    	  	
       	var pos=nserie_CO2_T+"MDat_meteo" + valor+"_CO2_T"; //Establecemos el punto de publicación de la leyenda (varibale y unidad)
      	var unid=document.getElementById(pos);
      	console.log("El valor de pos es: "+pos);
      	console.log("El valor de unid es: "+unid);
      	console.log("Etiq");
      	console.log(etiquetas);
    	unid.innerHTML = "<h3>"+vble+": </h3><h4>"+unit+"</h4>";
    	
    	
    	
    	var etiq = etiquetas.split(","); //Parseamos los datos y el tiempo para que sean valores numericos y poder representarlos
      	var dat = datos.split(",");
      	
      	for	(index = 0; index < etiq.length; index++) {
    		var aux = etiq[index];
    		etiq[index] = aux.substring(aux.indexOf("T")+1,aux.length-3); 
    	}
      	
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
            var graf=nserie_CO2_T+"graficaTest"+valor+"_CO2_T";
            var grafica = document.getElementById(graf).getContext('2d');
            // draw line chart
            var myLiveChart2 = new Chart(grafica).Line(graficaDatos);
            
            
            console.log("*** FIN FUNCION PINTAR");
            console.log(document.getElementById(nserie_CO2_T+"MDat_meteo1_CO2_T").style.display);
           
         } 
         
         /* Función para pintar las gráficas
          - nserie_CO2_T: numero de serie del sensor
          - mode: distingue entre recarga del portlet y el hacer click al boton 
         */
         function pintarGraficas_CO2_T(nserie_CO2_T,mode){
         	console.log("pintarGraficas2");
         	
         	var numGraficas = 8;
         	
         	var i=0;
         	for(i=1;i<numGraficas+1;i++){
         		
         		/* El usuario hace click */
         		if(document.getElementById("v"+i+"_CO2_T") && document.getElementById("v"+i+"_CO2_T").checked){       
	         		console.log("opcion 1");
	         		window.localStorage.setItem(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T","checked"); 
	         		document.getElementById(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T").style.display = "initial";
	         		document.getElementById(nserie_CO2_T+"graficaTest"+i+"_CO2_T").style.display = "initial";   
	         		pintar_CO2_T(i,nserie_CO2_T);  
	         		/* Se recarga el portlet*/       		
	         	}else{         	
	         		if(window.localStorage.getItem(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T") && window.localStorage.getItem(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T")=="checked" && mode == "reload"){
	         			if(document.getElementById(nserie_CO2_T+"graficaTest"+i+"_CO2_T")){
		         			console.log("opcion 2");
		         			document.getElementById(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T").style.display = "initial";
		         			document.getElementById(nserie_CO2_T+"graficaTest"+i+"_CO2_T").style.display = "initial";
		         			document.getElementById("v"+i+"_CO2_T").checked=true;
		         			pintar_CO2_T(i,nserie_CO2_T);   
		         			/* Grafica no seleccionada*/    
	         			} 	
	         		}else{
	         			console.log("opcion 3.0");
	         			if(document.getElementById(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T")){  
	         				console.log("opcion 3.1");
	         				window.localStorage.removeItem(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T"); 
	         				window.localStorage.setItem(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T","unckecked");
	         				console.log("opcion 3.2");
	         				document.getElementById(nserie_CO2_T+"MDat_meteo"+i+"_CO2_T").style.display = "none";
	         				document.getElementById(nserie_CO2_T+"graficaTest"+i+"_CO2_T").style.display = "none";
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
    
    <xsl:variable name="nserie_CO2_T" >
			<xsl:value-of select="/csixml/head/environment/serial-no"/>
  	</xsl:variable>	
   
   
   
	<xsl:variable name="instante_CO2_T" > <!-- Recogemos todos los valores de tiempo del XML -->
	<xsl:for-each select="r">
		<xsl:value-of select="@time"/>
		<xsl:if test="following::node()">, </xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  
	<xsl:variable name="datos1_CO2_T" > 
	<xsl:for-each select="//v1">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v1">,</xsl:if>			
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble1_CO2_T" >
  		<xsl:value-of select="//field[1]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit1_CO2_T" >
  		<xsl:value-of select="//field[1]/@units"/>
  	</xsl:variable>
	
	
	
	 <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',1,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos1_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble1_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit1_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    <xsl:variable name="datos2_CO2_T" >
	<xsl:for-each select="r/v2">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v2">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble2_CO2_T" >
  		<xsl:value-of select="//field[2]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit2_CO2_T" >
  		<xsl:value-of select="//field[2]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',2,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos2_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble2_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit2_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
	

    <xsl:variable name="datos3_CO2_T" >
	<xsl:for-each select="r/v3">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v3">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble3_CO2_T" >
  		<xsl:value-of select="//field[3]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit3_CO2_T" >
  		<xsl:value-of select="//field[3]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',3,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos3_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble3_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit3_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    
        <xsl:variable name="datos4_CO2_T" >
	<xsl:for-each select="r/v4">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v4">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble4_CO2_T" >
  		<xsl:value-of select="//field[4]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit4_CO2_T" >
  		<xsl:value-of select="//field[4]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',4,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos4_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble4_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit4_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
    
        <xsl:variable name="datos5_CO2_T" >
	<xsl:for-each select="r/v5">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v5">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble5_CO2_T" >
  		<xsl:value-of select="//field[5]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit5_CO2_T" >
  		<xsl:value-of select="//field[5]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',5,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos5_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble5_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit5_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
        <xsl:variable name="datos6_CO2_T" >
	<xsl:for-each select="r/v6">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v6">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble6_CO2_T" >
  		<xsl:value-of select="//field[6]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit6_CO2_T" >
  		<xsl:value-of select="//field[6]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',6,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos6_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble6_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit6_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
        <xsl:variable name="datos7_CO2_T" >
	<xsl:for-each select="r/v7">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v7">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble7_CO2_T" >
  		<xsl:value-of select="//field[7]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit7_CO2_T" >
  		<xsl:value-of select="//field[7]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',7,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos7_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble7_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit7_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
    
        <xsl:variable name="datos8_CO2_T" >
	<xsl:for-each select="r/v8">
		<xsl:value-of select="node()"/>
  		<xsl:if test="following::v8">,</xsl:if>	
  	</xsl:for-each>
  	</xsl:variable>	
  	<xsl:variable name="vble8_CO2_T" >
  		<xsl:value-of select="//field[8]/@name"/>
  	</xsl:variable>	
  	<xsl:variable name="unit8_CO2_T" >
  		<xsl:value-of select="//field[8]/@units"/>
  	</xsl:variable>


	
	<xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	
      	almacenar_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',8,
      				']]></xsl:text><xsl:value-of select="$instante_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$datos8_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$vble8_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[',
      				']]></xsl:text><xsl:value-of select="$unit8_CO2_T" /><xsl:text disable-output-escaping="yes"><![CDATA[');
 	</script> 
]]>
    </xsl:text>	
		

	
	
    
   <xsl:text disable-output-escaping="yes">
      <![CDATA[ 
      	<script> 
      	   
      		function init_CO2_T (nserie_CO2_T){ 
      		
      		
      		if (window.localStorage.getItem(nserie_CO2_T+"_valor_meteo_CO2_T")) {
				//var valor = window.localStorage.getItem(nserie_CO2_T+"_valor_meteo_CO2_T");
				//pintar(valor,nserie_CO2_T);
				console.log("pintarGraficas_CO2_T reload");
				pintarGraficas_CO2_T(nserie_CO2_T,"reload");
			}else{
				var unid=document.getElementById(nserie_CO2_T+"MDat_meteo_CO2_T");
    			//unid.innerHTML = "<h3>Seleccione una variable a mostrar.</h3>";
			}
			
		}
		init_CO2_T(']]></xsl:text><xsl:value-of select="$nserie_CO2_T" /> <xsl:text disable-output-escaping="yes"><![CDATA[');

		
</script> 
]]>
    </xsl:text>	
    
    <!-- Punto de publicacion para las graficas -->
 	
  <div>
  	<xsl:variable name="mycanvasHead1_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo1_CO2_T')"/>                     
    </xsl:variable>
    <xsl:variable name="mycanvas1_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest1_CO2_T')"/>                    
    </xsl:variable>
    
    
    <xsl:variable name="mycanvasHead2_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo2_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas2_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest2_CO2_T')"/>                       
    </xsl:variable>
    
        <xsl:variable name="mycanvasHead3_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo3_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas3_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest3_CO2_T')"/>                       
    </xsl:variable>
    
        <xsl:variable name="mycanvasHead4_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo4_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas4_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest4_CO2_T')"/>                       
    </xsl:variable>
    
        <xsl:variable name="mycanvasHead5_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo5_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas5_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest5_CO2_T')"/>                       
    </xsl:variable>
    
        <xsl:variable name="mycanvasHead6_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo6_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas6_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest6_CO2_T')"/>                       
    </xsl:variable>
    
        <xsl:variable name="mycanvasHead7_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo7_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas7_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest7_CO2_T')"/>                       
    </xsl:variable>
    
        <xsl:variable name="mycanvasHead8_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'MDat_meteo8_CO2_T')"/>                    
    </xsl:variable>
     <xsl:variable name="mycanvas8_CO2_T">
        <xsl:value-of select="concat($nserie_CO2_T,'graficaTest8_CO2_T')"/>                       
    </xsl:variable>
    
        

    
   	 
	 <div id="{$mycanvasHead1_CO2_T}" ></div>
	 <canvas id="{$mycanvas1_CO2_T}" ></canvas>	
	 
     		
	 <div id="{$mycanvasHead2_CO2_T}" ></div>
	 <canvas id="{$mycanvas2_CO2_T}" ></canvas>
	 
	 <div id="{$mycanvasHead3_CO2_T}" ></div>
	 <canvas id="{$mycanvas3_CO2_T}" ></canvas>
	 
	 <div id="{$mycanvasHead4_CO2_T}" ></div>
	 <canvas id="{$mycanvas4_CO2_T}" ></canvas>
	 
	 <div id="{$mycanvasHead5_CO2_T}" ></div>
	 <canvas id="{$mycanvas5_CO2_T}" ></canvas>
	 
	 <div id="{$mycanvasHead6_CO2_T}" ></div>
	 <canvas id="{$mycanvas6_CO2_T}" ></canvas>
	 
	 <div id="{$mycanvasHead7_CO2_T}" ></div>
	 <canvas id="{$mycanvas7_CO2_T}" ></canvas>
	 
	 <div id="{$mycanvasHead8_CO2_T}" ></div>
	 <canvas id="{$mycanvas8_CO2_T}" ></canvas>
	 

	 	  	
	 </div>
	 
	 <table>
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="1" id="v1_CO2_T">
		<xsl:value-of select="//field[1]/@name"/>
	</input>
	</td></tr>
	
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="2" id="v2_CO2_T">
		<xsl:value-of select="//field[2]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="3" id="v3_CO2_T">
		<xsl:value-of select="//field[3]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="4" id="v4_CO2_T">
		<xsl:value-of select="//field[4]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="5" id="v5_CO2_T">
		<xsl:value-of select="//field[5]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="6" id="v6_CO2_T">
		<xsl:value-of select="//field[6]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="7" id="v7_CO2_T">
		<xsl:value-of select="//field[7]/@name"/>
	</input>
	</td></tr>
	
	<tr><td>
	<input type="checkbox" name="valor_CO2_T" value="8" id="v8_CO2_T">
		<xsl:value-of select="//field[8]/@name"/>
	</input>
	</td></tr>
	
	
		<!-- Botón para mostrar gráficas  -->
	<tr><td>
	<button class="btn" type="submit" name="valor_CO2_T" onclick="pintarGraficas_CO2_T('{$nserie_CO2_T}','button')">
			Mostrar
	</button> 
	</td></tr>
	</table>
	 
	 
   </div>			 
</xsl:template>	
</xsl:stylesheet>


      	
      	

