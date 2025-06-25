
export ROOT="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"
echo "Root folder is ${ROOT}"

mount "${ROOT}/fs/fat.img" "${ROOT}/fs/mountpoint"

if [ -f "${ROOT}/fs/mountpoint/out.txt" ]; then
  echo "out.txt detected, removing"
  rm "${ROOT}/fs/mountpoint/out.txt"
  umount "${ROOT}/fs/mountpoint"
  mount "${ROOT}/fs/fat.img" "${ROOT}/fs/mountpoint"
  [ -f "${ROOT}/fs/mountpoint/out.txt" ] && echo "The file is present after deleting, something is wrong" && exit 1
fi

umount "${ROOT}/fs/mountpoint"
{
  cd "${ROOT}"
  BUILDKIT_PROGRESS=plain docker compose up --build -d
}

mount "${ROOT}/fs/fat.img" "${ROOT}/fs/mountpoint"
while [ ! -f "${ROOT}/fs/mountpoint/out.txt" ]; do
  umount "${ROOT}/fs/mountpoint"
  echo "out.txt still not detected"
  sleep 1
  mount "${ROOT}/fs/fat.img" "${ROOT}/fs/mountpoint"
done

echo "out.txt detected, test passed"
rm "${ROOT}/fs/mountpoint/out.txt"
umount "${ROOT}/fs/mountpoint"
exit 0





