#!/bin/sh
file="cancellation.txt"; touch $file
booking="booking.txt"
bus="bus.txt"
payment="payment.txt"

while true
do
echo "======================================================"
echo "            CANCELLATION MANAGEMENT SYSTEM"
echo "======================================================"
echo "1. Cancel Booking"
echo "2. View All Cancellations"
echo "3. Back to Main Menu"
echo "------------------------------------------------------"

printf "Please enter your choice: "
read ch

case $ch in

# ---------------- CANCEL BOOKING ----------------
1)
printf "Enter Booking ID to cancel: "
read bid

# Check booking exists
bline=$(grep "^$bid|" $booking)

if [ -z "$bline" ]; then
    echo "Invalid Booking ID. No such booking exists."
    continue
fi

printf "Enter Cancellation ID (e.g., CAN-1): "
read cid

# Duplicate cancellation ID check
check=$(grep "^$cid|" $file)
if [ ! -z "$check" ]; then
    echo "This Cancellation ID already exists."
    continue
fi

printf "Enter Reason for Cancellation: "
read reason

# Extract booking details
busno=$(echo $bline | cut -d'|' -f4)
cat=$(echo $bline | cut -d'|' -f5)
qty=$(echo $bline | cut -d'|' -f6)

# 🔥 Restore seats in bus.txt
line=$(awk -F'|' -v b="$busno" -v c="$cat" '
tolower($2)==tolower(b) && tolower($7)==tolower(c)
' $bus)

old=$(echo $line | cut -d'|' -f10)
new=$((old + qty))

awk -F'|' -v b="$busno" -v c="$cat" -v new="$new" '
BEGIN{OFS="|"}
{
    if (tolower($2)==tolower(b) && tolower($7)==tolower(c))
        $10=new
    print
}' $bus > temp && mv temp $bus

# 🔥 Delete booking
awk -F'|' -v id="$bid" '$1!=id' $booking > temp && mv temp $booking

# 🔥 Delete payment (important fix)
if [ -f "$payment" ]; then
    awk -F'|' -v id="$bid" '$2!=id' $payment > temp && mv temp $payment
fi

# Save cancellation
echo "$cid|$bid|$reason|cancelled" >> $file

echo "------------------------------------------------------"
echo "Booking has been cancelled successfully."
echo "Seats have been restored and payment (if any) removed."
echo "------------------------------------------------------"
;;

# ---------------- VIEW CANCELLATIONS ----------------
2)
if [ ! -s $file ]; then
    echo "No cancellation records are available."
else
    printf "%-10s | %-10s | %-20s | %-10s\n" \
    "CancelID" "BookID" "Reason" "Status"

    echo "-------------------------------------------------------------"

    while IFS='|' read a b c d
    do
        [ -z "$a" ] && continue
        printf "%-10s | %-10s | %-20s | %-10s\n" \
        "$a" "$b" "$c" "$d"
    done < $file
fi
;;

3) break ;;

*)
echo "Invalid choice. Please try again."
;;

esac
done

