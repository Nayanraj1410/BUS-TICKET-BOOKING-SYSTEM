#!/bin/sh
file="payment.txt"; touch $file
booking="booking.txt"

while true
do
echo "======================================================"
echo "              PAYMENT MANAGEMENT SYSTEM"
echo "======================================================"
echo "1. Make Payment"
echo "2. View All Payments"
echo "3. Back to Main Menu"
echo "------------------------------------------------------"

printf "Please enter your choice: "
read ch

case $ch in

# ---------------- MAKE PAYMENT ----------------
1)
printf "Enter Payment ID (e.g., PAY-1): "
read pid

# Duplicate Payment ID check
check=$(grep "^$pid|" $file)
if [ ! -z "$check" ]; then
    echo "This Payment ID already exists. Please use a different ID."
    continue
fi

printf "Enter Booking ID: "
read bid

# Check booking exists
bline=$(grep "^$bid|" $booking)

if [ -z "$bline" ]; then
    echo "Invalid Booking ID. Please enter a valid one."
    continue
fi

# Check if already paid
paid=$(awk -F'|' -v b="$bid" '$2==b' $file)

if [ ! -z "$paid" ]; then
    echo "Payment has already been completed for this Booking ID."
    continue
fi

# Extract details
name=$(echo $bline | cut -d'|' -f2)
phone=$(echo $bline | cut -d'|' -f3)
busno=$(echo $bline | cut -d'|' -f4)
cat=$(echo $bline | cut -d'|' -f5)
qty=$(echo $bline | cut -d'|' -f6)
amount=$(echo $bline | cut -d'|' -f7)

# Show payment summary
echo "------------------------------------------------------"
echo "Booking Details:"
echo "Booking ID : $bid"
echo "Name       : $name"
echo "Phone      : $phone"
echo "Bus No     : $busno"
echo "Category   : $cat"
echo "Seats      : $qty"
echo "Total Amount Payable: ₹$amount"
echo "------------------------------------------------------"

printf "Do you want to proceed with the payment? (y/n): "
read confirm

if [ "$confirm" != "y" ]; then
    echo "Payment has been cancelled by the user."
    continue
fi

# Payment method
printf "Enter Payment Method (UPI / Card / Cash): "
read method

# Save payment
echo "$pid|$bid|$amount|$method|paid" >> $file

echo "------------------------------------------------------"
echo "Payment has been completed successfully."
echo "------------------------------------------------------"
;;

# ---------------- VIEW PAYMENTS ----------------
2)
if [ ! -s $file ]; then
    echo "No payment records are available."
else
    printf "%-10s | %-10s | %-10s | %-12s | %-10s\n" \
    "PayID" "BookID" "Amount" "Method" "Status"

    echo "-------------------------------------------------------------"

    while IFS='|' read a b c d e
    do
        [ -z "$a" ] && continue
        printf "%-10s | %-10s | %-10s | %-12s | %-10s\n" \
        "$a" "$b" "$c" "$d" "$e"
    done < $file
fi
;;

3) break ;;

*)
echo "Invalid choice. Please try again."
;;

esac
done

