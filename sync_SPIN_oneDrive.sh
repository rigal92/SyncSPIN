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

rclone bisync "${HOME}/Documents" "${DRIVE_NAME}:Documents/" --filters-file "${HOME}/Dev/SyncSPIN/${FILTER_FILE}" "${parameters[@]}" 
rclone bisync "${HOME}/Templates" "${DRIVE_NAME}:Templates/" "${parameters[@]}" 
