#! /bin/bash

func_usage ()
{
  echo "\
Usage: ./sync_SPIN_oneDrive.sh [OPTION]...

Sync OneDrive work storage 

Options:
  -n, --dry-run         print modifications but don't perform them
  --resync              perform a resync of the folders. The option 
                        --track-renames is removed in this case.
  -f, --folder folder   sync specific folder. If not provided everything is synced
  -h, --help            print this help and exit
  "
}
case `cat /proc/sys/kernel/hostname` in 
    "rigal-x302ua")
        FILTER_FILE=".Asus_filter_file"
        DRIVE_NAME="SPIN"
        ;;
    "riccardo-PRO-H610-DP180-MS-B0A7")
        FILTER_FILE=".WorkPC_filter_file"
        DRIVE_NAME="CNR"
        ;;
    *)
        echo "Unknown device"
        exit 1
esac




parameters=("--create-empty-src-dirs" "--compare" "size,modtime,checksum" "--slow-hash-sync-only" "-MvP" "--resilient")
resync=
FOLDER=""

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run | -n )
            parameters+=("--dry-run")
            shift 
            ;;
        --resync)
            resync=true
            shift
            ;;
        --folder | f)
            FOLDER="$2"
            shift
            shift
            ;;

        --help | -h )
            func_usage; exit 0 ;;
        -* )
            echo "sync_SPIN_oneDrive: unknown option $1" 1>&2
            echo "Try 'sync_SPIN_oneDrive --help' for more information." 1>&2
            exit 1 ;;
        * )
            break ;;


    esac
    done

if [ -z "$resync" ]; then
    parameters+=("--track-renames")
else
    parameters+=("--resync")
fi

if [[ $FOLDER != "" ]]; then
    FOLDER=$(realpath "$FOLDER")
    if [[ $FOLDER == "${HOME}/Documents"* ]]; then # check if it starts with HOME/Documents
        DRIVE_FOLDER="${FOLDER#${HOME}/Documents}"
    else 
        echo "$FOLDER is not in home"
        exit 0
    fi
    rclone bisync "$FOLDER" "${DRIVE_NAME}:${DRIVE_FOLDER}" --filters-file "${HOME}/Dev/SyncSPIN/${FILTER_FILE}" "${parameters[@]}" 
else
    rclone bisync "${HOME}/Documents" "${DRIVE_NAME}:Documents/" --filters-file "${HOME}/Dev/SyncSPIN/${FILTER_FILE}" "${parameters[@]}" 
    rclone bisync "${HOME}/Templates" "${DRIVE_NAME}:Templates/" "${parameters[@]}" 
    rclone bisync "${HOME}/.config/matplotlib/" "${DRIVE_NAME}:.config/matplotlib/" "${parameters[@]}" 
fi



