# Usamos una versión de Python más moderna y completa para evitar errores de compilación
FROM python:3.11-slim

# Evitar archivos .pyc y forzar logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA
# Añadimos pkg-config, libcairo2-dev y otras herramientas que pycairo exige
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libcairo2-dev \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Actualizamos pip por si acaso
RUN pip install --upgrade pip

# Instalamos las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el resto del código
COPY . .

# Configuración de usuario para Hugging Face
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

EXPOSE 7860

# Asegúrate de que tu archivo de arranque se llame app.py o cámbialo aquí
CMD ["python", "app.py"]
