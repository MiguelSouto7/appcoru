# appcoru

A new Flutter project.

Aplicación Flutter que muestra información en tiempo real del sistema de bicicletas públicas de A Coruña, usando la API GBFS oficial.

## Enfoque

- Arquitectura MVVM: Se ha aplicado el patrón MVVM (Modelo-Vista-ViewModel), que garantiza una separación clara entre la lógica de negocio, la presentación de la interfaz y los datos, facilitando el mantenimiento y la escalabilidad del código.
- Conexión con la API real de BiciCoruña: La aplicación se conecta directamente a la API GBFS oficial del sistema de bicicletas públicas de A Coruña, lo que permite obtener y mostrar información actualizada en tiempo real sobre la disponibilidad de bicis y anclajes.
- Experiencia de usuario intuitiva: La interfaz combina información relevante con gráficos claros y fáciles de interpretar, ayudando al usuario a tomar decisiones rápidas y prácticas sin necesidad de navegar por menús complejos.
- Funcionalidad completa: La aplicación cubre todo el flujo de uso esperado: desde la consulta general del estado del sistema hasta el detalle de una estación concreta y la generación de un informe en PDF, ofreciendo una solución integral y lista para el uso real.

## Capturas

### Pantalla principal - Informe global
![Pantalla principal con gráfico de barras y métricas](capturas/pantalla_principal.png)

### Pantalla de detalle - Distribución por estación
![Pantalla de detalle con gráfico circular](capturas/pantalla_detalle.png)

### PDF generado - Informe completo
![PDF generado con recomendación práctica](capturas/pdf_ejemplo.png)

## Gráficas elegidas

## Gráfico A: Barras (Top 5 estaciones por bicis totales)
El gráfico de barras permite identificar de un vistazo las cinco estaciones con mayor disponibilidad de bicis en tiempo real. Al representar cada estación como una categoría independiente, el gráfico de barras facilita la comparación directa de cantidades discretas, lo que lo convierte en una elección técnica adecuada para visualizar y contrastar los niveles de disponibilidad entre distintas ubicaciones del sistema.

## Gráfico B: Circular/Pie Chart (Distribución por estación)
El gráfico circular muestra cómo está repartida en este momento una estación concreta: cuántas bicis mecánicas hay, cuántas e-bikes y cuántos anclajes libres para dejar la bici. Al representar toda la estación como un círculo dividido en partes, se entiende fácilmente qué recursos están más disponibles en ese lugar. Este tipo de gráfico es muy visual y permite ver de un vistazo la proporción de cada elemento, algo que resulta útil para decidir si merece la pena acercarse a esa estación.

## Dependencias usadas

- http: ^1.6.0 - Actualizado para realizar peticiones HTTP a la API externa
- fl_chart: ^0.68.0 - Gráficos de barras y circulares
- pdf: ^3.10.4 - Generación de documentos PDF
- printing: ^5.11.1 - Visualización y exportación de PDFs
- http: ^0.9.2 - Comunicación con la API REST
- provider: ^6.1.2 - Gestión de estado con patrón MVVM

## Ejemplo PDF