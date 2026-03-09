-- HITO 3: Automatización Inteligente - Proyecto A (RAG)

-- 1. Tabla para el control de documentos procesados
CREATE TABLE IF NOT EXISTS documentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    ruta_archivo TEXT,
    num_chunks INTEGER,
    fecha_procesado TIMESTAMP DEFAULT NOW()
);

-- Índice para búsquedas rápidas por nombre de archivo
CREATE INDEX IF NOT EXISTS idx_documentos_nombre ON documentos(nombre);

-- 2. Tabla para el historial de consultas RAG
-- Nota: Usamos TEXT[] para almacenar la lista de documentos que sirvieron de contexto
CREATE TABLE IF NOT EXISTS consultas_rag (
    id SERIAL PRIMARY KEY,
    pregunta TEXT NOT NULL,
    respuesta TEXT NOT NULL,
    documentos_usados TEXT[], 
    timestamp TIMESTAMP DEFAULT NOW()
);

-- Índice para consultas recientes (optimiza ordenación por fecha)
CREATE INDEX IF NOT EXISTS idx_consultas_timestamp ON consultas_rag(timestamp DESC);

-- 3. Tabla adicional (Opcional pero recomendada) 
-- Para guardar los logs de errores si algo falla en n8n
CREATE TABLE IF NOT EXISTS logs_errores (
    id SERIAL PRIMARY KEY,
    nodo_error VARCHAR(100),
    mensaje_error TEXT,
    fecha TIMESTAMP DEFAULT NOW()
);