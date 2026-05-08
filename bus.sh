#!/bin/sh
file="bus.txt"; touch $file

while true
do
echo "======================================================"
echo "             BUS MANAGEMENT SYSTEM"
echo "======================================================"
echo "1. Add New Bus"
echo "2. View All Buses"
echo "3. Search Bus by Route"
echo "4. Delete Bus"
echo "5. Back to Main Menu"
echo "------------------------------------------------------"

printf "Please enter your choice: "
read ch

case $ch in

1)
printf "Enter Bus Name: "
read name

printf "Enter Bus Number (e.g., BUS-101): "
read busno

# Duplicate check
check=$(awk -F'|' -v b="$busno" '$2==b' $file)
if [ ! -z "$check" ]; then
    echo "This Bus Number already exists. Please use a unique Bus Number."
    continue
fi

printf "Enter Source City: "
read src

printf "Enter Destination City: "
read dest

printf "Enter Departure Time (e.g., 10:00AM): "
read dtime

printf "Enter Arrival Time (e.g., 03:00PM): "
read atime

printf "Enter Category (AC / Non-AC / Sleeper): "
read cat

printf "Enter Ticket Price: "
read price

printf "Enter Total Seats: "
read total

avail=$total

echo "$name|$busno|$src|$dest|$dtime|$atime|$cat|$price|$total|$avail" >> $file

echo "Bus has been added successfully with all details."
;;

2)
if [ ! -s $file ]; then
    echo "No bus records are available at the moment."
else
    printf "%-12s | %-8s | %-10s | %-12s | %-8s | %-8s | %-10s | %-6s | %-6s | %-6s\n" \
    "Name" "BusNo" "Source" "Destination" "Dep" "Arr" "Category" "Price" "Total" "Avail"
    
    echo "-------------------------------------------------------------------------------------------------------"

    while IFS='|' read a b c d e f g h i j
    do
        [ -z "$a" ] && continue
        printf "%-12s | %-8s | %-10s | %-12s | %-8s | %-8s | %-10s | %-6s | %-6s | %-6s\n" \
        "$a" "$b" "$c" "$d" "$e" "$f" "$g" "$h" "$i" "$j"
    done < $file
fi
;;

3)
printf "Enter Source City: "
read src
printf "Enter Destination City: "
read dest

res=$(awk -F'|' -v s="$src" -v d="$dest" '
tolower($3)==tolower(s) && tolower($4)==tolower(d)
' $file)

if [ -z "$res" ]; then
    echo "No buses found for the given route."
else
    echo "Matching buses for your selected route are:"
    printf "%-12s | %-8s | %-10s | %-12s | %-8s | %-8s | %-10s | %-6s | %-6s | %-6s\n" \
    "Name" "BusNo" "Source" "Destination" "Dep" "Arr" "Category" "Price" "Total" "Avail"
    
    echo "-------------------------------------------------------------------------------------------------------"

    echo "$res" | while IFS='|' read a b c d e f g h i j
    do
        printf "%-12s | %-8s | %-10s | %-12s | %-8s | %-8s | %-10s | %-6s | %-6s | %-6s\n" \
        "$a" "$b" "$c" "$d" "$e" "$f" "$g" "$h" "$i" "$j"
    done
fi
;;

4)
printf "Enter Bus Number to delete: "
read id

res=$(awk -F'|' -v b="$id" '$2==b' $file)

if [ -z "$res" ]; then
    echo "No matching bus record was found."
else
    awk -F'|' -v b="$id" '$2!=b' $file > temp && mv temp $file
    echo "Bus record has been deleted successfully."
fi
;;

5) break ;;

*)
echo "Invalid choice. Please try again."
;;

esac
done

