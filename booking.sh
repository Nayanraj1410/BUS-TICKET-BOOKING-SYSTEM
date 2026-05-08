#!/bin/sh
file="booking.txt"; touch $file
bus="bus.txt"

while true
do
echo "======================================================"
echo "             BOOKING MANAGEMENT SYSTEM"
echo "======================================================"
echo "1. Create New Booking"
echo "2. View All Bookings"
echo "3. Delete Booking"
echo "4. Search Booking"
echo "5. View Ticket"
echo "6. Back to Main Menu"
echo "------------------------------------------------------"

printf "Please enter your choice: "
read ch

case $ch in

# ---------------- CREATE BOOKING ----------------
1)
printf "Enter Booking ID (e.g., BKG-1): "
read bid

check=$(grep "^$bid|" $file)
if [ ! -z "$check" ]; then
    echo "This Booking ID already exists. Please use a different ID."
    continue
fi

printf "Enter Customer Name: "
read name

printf "Enter Phone Number: "
read phone

printf "Enter Source City: "
read src
printf "Enter Destination City: "
read dest

# Show buses
res=$(awk -F'|' -v s="$src" -v d="$dest" '
tolower($3)==tolower(s) && tolower($4)==tolower(d)
' $bus)

if [ -z "$res" ]; then
    echo "No buses are available for the selected route."
    continue
fi

echo "Available buses for your route:"
printf "%-10s | %-8s | %-10s | %-10s | %-8s | %-8s | %-10s | %-6s | %-6s\n" \
"Name" "BusNo" "Source" "Destination" "Dep" "Arr" "Category" "Price" "Avail"

echo "-------------------------------------------------------------------------------------"

echo "$res" | while IFS='|' read a b c d e f g h i j
do
    printf "%-10s | %-8s | %-10s | %-10s | %-8s | %-8s | %-10s | %-6s | %-6s\n" \
    "$a" "$b" "$c" "$d" "$e" "$f" "$g" "$h" "$j"
done

printf "Enter Bus Number: "
read busno

printf "Enter Category (AC / Non-AC / Sleeper): "
read cat

line=$(awk -F'|' -v b="$busno" -v c="$cat" '
tolower($2)==tolower(b) && tolower($7)==tolower(c)
' $bus)

if [ -z "$line" ]; then
    echo "Invalid Bus Number or Category."
    continue
fi

price=$(echo $line | cut -d'|' -f8)
avail=$(echo $line | cut -d'|' -f10)

printf "Enter number of seats to book: "
read qty

if [ "$qty" -gt "$avail" ]; then
    echo "Only $avail seats are available. Please try again."
    continue
fi

total=$((price * qty))

# Save booking
echo "$bid|$name|$phone|$busno|$cat|$qty|$total" >> $file

# Update seats
new_avail=$((avail - qty))

awk -F'|' -v b="$busno" -v c="$cat" -v new="$new_avail" '
BEGIN{OFS="|"}
{
    if (tolower($2)==tolower(b) && tolower($7)==tolower(c))
        $10=new
    print
}' $bus > temp && mv temp $bus

echo "------------------------------------------------------"
echo "Booking has been completed successfully."
echo "Total amount for your booking is: ₹$total"
echo "------------------------------------------------------"
;;

# ---------------- VIEW BOOKINGS ----------------
2)
if [ ! -s $file ]; then
    echo "No booking records are available."
else
    printf "%-10s | %-12s | %-12s | %-8s | %-10s | %-5s | %-8s\n" \
    "BookID" "Name" "Phone" "BusNo" "Category" "Seats" "Amount"

    echo "---------------------------------------------------------------------"

    while IFS='|' read a b c d e f g
    do
        [ -z "$a" ] && continue
        printf "%-10s | %-12s | %-12s | %-8s | %-10s | %-5s | %-8s\n" \
        "$a" "$b" "$c" "$d" "$e" "$f" "$g"
    done < $file
fi
;;

# ---------------- DELETE BOOKING ----------------
3)
printf "Enter Booking ID to delete: "
read id

line=$(grep "^$id|" $file)

if [ -z "$line" ]; then
    echo "No booking record found."
else
    busno=$(echo $line | cut -d'|' -f4)
    cat=$(echo $line | cut -d'|' -f5)
    qty=$(echo $line | cut -d'|' -f6)

    old=$(awk -F'|' -v b="$busno" -v c="$cat" '
tolower($2)==tolower(b) && tolower($7)==tolower(c){print $10}' $bus)

    new=$((old + qty))

    awk -F'|' -v b="$busno" -v c="$cat" -v new="$new" '
BEGIN{OFS="|"}
{
    if (tolower($2)==tolower(b) && tolower($7)==tolower(c))
        $10=new
    print
}' $bus > temp && mv temp $bus

    awk -F'|' -v id="$id" '$1!=id' $file > temp && mv temp $file

    echo "Booking has been deleted and seats have been restored."
fi
;;

# ---------------- SEARCH ----------------
4)
printf "Enter Booking ID to search: "
read id

grep "^$id|" $file || echo "No booking found."
;;

# ---------------- TICKET ----------------
5)
printf "Enter Booking ID to view ticket: "
read bid

res=$(grep "^$bid|" $file)

if [ -z "$res" ]; then
    echo "No booking record found."
else
    name=$(echo $res | cut -d'|' -f2)
    phone=$(echo $res | cut -d'|' -f3)
    busno=$(echo $res | cut -d'|' -f4)
    cat=$(echo $res | cut -d'|' -f5)
    qty=$(echo $res | cut -d'|' -f6)
    amount=$(echo $res | cut -d'|' -f7)

    echo "======================================================"
    echo "                   TICKET DETAILS"
    echo "======================================================"
    echo "Booking ID : $bid"
    echo "Name       : $name"
    echo "Phone      : $phone"
    echo "Bus No     : $busno"
    echo "Category   : $cat"
    echo "Seats      : $qty"
    echo "Amount     : ₹$amount"
    echo "------------------------------------------------------"

    i=1
    while [ $i -le $qty ]
    do
        echo "Ticket No : TKT-$bid-$i | Seat-$i"
        i=$((i+1))
    done

    echo "======================================================"
fi
;;

6) break ;;

*)
echo "Invalid choice. Please try again."
;;

esac
done

