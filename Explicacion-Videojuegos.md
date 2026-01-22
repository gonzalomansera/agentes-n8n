# Ejercicio 1: Cargar 200 Videojuegos en Qdrant

**Módulo:** Desarrollo de Agentes IA para Web  
**Alumno:** Gonzalo Mansera  
**Fecha:** 22 de enero de 2026  

---

## 1. Introducción
El objetivo de este proyecto es la automatización de la carga de una base de datos de 200 videojuegos en la base de datos vectorial **Qdrant**. Este proceso permite realizar búsquedas semánticas (por significado) en lugar de búsquedas por palabras clave, utilizando **Ollama** para generar representaciones matemáticas (embeddings) del contenido de los juegos.

---

## 2. Tecnologías Utilizadas
- **n8n:** Orquestador del flujo de trabajo.  
- **Ollama (CPU):** Ejecución local del modelo `nomic-embed-text:latest` para la generación de vectores.  
- **Qdrant:** Almacenamiento vectorial y de metadatos.  
- **Docker:** Entorno de contenedores con una red interna denominada `redinterna` para la comunicación entre servicios.

---

## 3. Explicación de los Nodos del Workflow

### 3.1. Manual Trigger
Es el punto de entrada que permite iniciar la ejecución del flujo de forma controlada.

### 3.2. Code Node: "Generar 200 Videojuegos"
Este nodo contiene un script en **JavaScript** que define un array con 200 objetos de videojuegos. Cada objeto incluye campos como `id`, `nombre`, `genero`, `descripcion`, `tematica`, `precio`, entre otros.  

**Función:** Retornar los datos en un formato compatible con n8n (`{ json: { ... } }`).

### 3.3. Code Node: "Preparar Documentos"
Este es el nodo de transformación crítica.

**Lógica:** Recorre el array anterior y genera para cada item un objeto con dos partes:  
- `pageContent`: Un bloque de texto plano que concatena el título, género, temática y descripción. Este texto será el que la IA analice.  
- `metadata`: Un objeto que guarda toda la información original del juego para que pueda ser recuperada tras una búsqueda.

### 3.4. Embeddings Ollama
Este nodo se conecta al contenedor `ollama_cpu` a través de la red interna de Docker (`http://ollama_cpu:11434`).  

- **Modelo:** `nomic-embed-text:latest`  
- **Función:** Convierte el `pageContent` en un vector numérico de 768 dimensiones.

### 3.5. Qdrant Vector Store
Recibe los vectores de Ollama y los documentos del paso de preparación.  

- **Acción:** Insert Documents  
- **Colección:** `videojuegos2` (en el JSON original figuraba como "Videojuegos", pero se ajustó para la entrega)  
- **Conexión:** Se comunica con el servicio **Qdrant** en el puerto `6333`.

---

## 4. Explicación del Código JavaScript
En el nodo de transformación se utiliza la función `.map()` de **JavaScript** para procesar los 200 elementos de forma eficiente.

```javascript
return items.map((item) => {
  const data = item.json;
  // Unión de campos para enriquecer el contexto semántico
  const textoParaEmbedding = `Título: ${data.nombre}. Género: ${data.genero}. Descripción: ${data.descripcion}.`;
  
  return {
    json: {
      pageContent: textoParaEmbedding, // Lo que se vectoriza
      metadata: { ...data }            // Lo que se guarda como información
    }
  };
});
