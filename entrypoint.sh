#!/bin/bash

nds_rom=""
watchdog_mode=yes



# If preferred ROM exists, use it
if [ -f "$preferred_rom" ]; then
    preferred_rom="/roms/rom.nds"
    nds_rom=${preferred_rom}
    echo "Using preferred ROM: $preferred_rom"
else
  # Otherwise, search for first .nds file in directory
  search_dir="/roms"
  nds_files=($(find "$search_dir" -maxdepth 1 -type f -name '*.nds'))

  # Check if any .nds files were found
  if [ ${#nds_files[@]} -eq 0 ]; then
      echo "No .nds files found in $search_dir"
      exit 1
  fi

  # Use the first .nds file found
  first_nds="${nds_files[0]}"
  echo "Using fallback ROM: $first_nds"
  nds_rom=${first_nds}
fi


if [ ${watchdog_mode}==yes ]; then
  desmume-cli ${nds_rom} --cflash-image /fs/fat.img ${suffix}  # Run in background to watchdog-entrypoint.sh exit-code
else
  desmume-cli ${nds_rom} --cflash-image /fs/fat.img ${suffix}
fi

