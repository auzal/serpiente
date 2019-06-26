# serpiente
serpiente de proyecto biopus

nota: siempre la versión numérica mayor es la que va

# instrucciones y notas motor de mapping
• el estado del motor siempre está explicitado arriba a la izquierda  
• para cambiar de modo presionar 'm'  

• modo "point calibration":  
     • CLICK o ENTER en cualquier lado pone un punto en las coordenadas del mouse  
     • el punto seleccionado tiene un marcador alrededor  
     • TAB para ciclar el selector de puntos  
     • FLECHAS para mover el punto  
     • FLECHAS + SHIFT para mover el punto a incrementos mas grandes  

• modo "triangle calibration":  
  • CLICK para agregar un punto a un triangulo. El punto que se agrega es el más cercano al mouse, marcado por una línea blanca. El sistema no permite que se agregue el mismo punto dos veces al mismo triángulo. Una vez que se agregaron tres puntos, aparece el triángulo creado.   

• modo "running":  
  • CLICK para disparar la animación en el triángulo cuyo centroide se encuentra más cerca al mouse  

# cosas que faltan desarrollar
• guardado y carga de configuración de triángulos y puntos  
• eliminar puntos y triángulos  
• mejorar la interfaz (por ej: que muestre el proceso de configuración de triángulos)  
• agregar control de color de texto y fondo a los triángulos  
• hacer un pequeño offset hacia adentro de cada triángulo, para contar el hierro  
• corregir bug animación (rebote de texto cuando entra en un nuevo segmente del espiral)  
• tamaño de texto dinámico en función al tamaño del triángulo?  
