#!/bin/bash

# Nombre del modelo y autor
MODEL_NAME="SuperSeg Model"
AUTHOR_NAME="Adrián Valls Carbó"

# Función para mostrar el uso del script
mostrar_uso() {
    echo "############################################################"
    echo "#############          $MODEL_NAME          #############"
    echo "#############          by $AUTHOR_NAME          #############"
    echo "############################################################"
    echo ""
    echo "Usage: $0 -i <input file> [-o <output file>] [-d <input directory>] [-l <list file>]"
    echo "  -i <input file>  : Specify the input file."
    echo "  -o <output file> : Specify the output file (optional)."
#    echo "  -d <input directory> : Specify the input directory containing .nii or .nii.gz files."
#    echo "  -l <list file>   : Specify a .txt file with a list of input files (one per line)."
    echo "  -h               : Display this help message."
    exit 1
}

# Inicializar variables
INPUT_FILE=""
OUTPUT_FILE=""
LIST_FILE=""
INPUT_DIR=""

# Procesar argumentos
while getopts ":i:o:h" opt; do
    case $opt in
        i) INPUT_FILE="$OPTARG"
        ;;
        o) OUTPUT_FILE="$OPTARG"
        ;;
        l) LIST_FILE="$OPTARG"
        ;;
        d) INPUT_DIR="$OPTARG"
        ;;
        h) mostrar_uso
        ;;
        *) mostrar_uso
        ;;
    esac
done

# Verificar que se haya especificado el archivo de entrada, el directorio o la lista de archivos
if [ -z "$INPUT_FILE" ] && [ -z "$INPUT_DIR" ] && [ -z "$LIST_FILE" ]; then
    mostrar_uso
fi

# Definir el nombre del contenedor Docker
DOCKER_IMAGE="synapnet:latest"

# Construir la imagen Docker (opcional, si no ha sido construida previamente)
#docker build -t $DOCKER_IMAGE .

# Función para procesar un solo archivo
procesar_archivo() {
    local input_file=$1
    local output_file

    if [ -n "$2" ]; then
        output_file=$2
    else
        output_file="${input_file%.nii.gz}"
    fi

    echo "Processing: $input_file -> $output_file"
    docker run --rm -v $(pwd):/usr/src/app $DOCKER_IMAGE python3 main.py --input $input_file --output $output_file
}

# Procesar archivo único
if [ -n "$INPUT_FILE" ]; then
    procesar_archivo "$INPUT_FILE" "$OUTPUT_FILE"
fi

# Procesar lista de archivos
#if [ -n "$LIST_FILE" ]; then
#    while IFS= read -r input_file; do
#        procesar_archivo "$input_file"
#    done < "$LIST_FILE"
#fi

# Procesar todos los archivos en un directorio
#if [ -n "$INPUT_DIR" ]; then
#    for input_file in "$INPUT_DIR"/*.{nii,nii.gz}; do
#        [ -e "$input_file" ] || continue
#        procesar_archivo "$input_file"
#    done
#fi
