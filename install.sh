#!/bin/bash

# Verificar si la carpeta ./models existe, si no, crearla
if [ ! -d "./models" ]; then
  echo "Creando la carpeta ./models..."
  mkdir -p ./models
fi

# Definir la URL del modelo en Google Drive
GDRIVE_MODEL_URL="https://drive.google.com/drive/folders/1VHEj-vU-f4qNhCKkYODlVQIfXkCRAuHs?usp=drive_link"

# Descargar el modelo desde Google Drive a la carpeta ./models
echo "Descargando el modelo desde Google Drive..."
wget --no-check-certificate "$GDRIVE_MODEL_URL" -O ./models/

# Verificar si la descarga fue exitosa
if [ $? -eq 0 ]; then
    echo "El modelo se descargó correctamente."

else
    echo "Hubo un problema al descargar el modelo."
    exit 1
fi