#!/bin/bash

# Make sure the temporary inventory is empty
echo > inventory/sanitised_inventory.txt

# Read the arguments for the script
while getopts i:c: flag
do
    case "${flag}" in
        i) inventory=${OPTARG};;
        c) check_target=${OPTARG};;
    esac
done

# Sanitise the inventory by removing quotes
while IFS= read -r line; do
    echo $line | tr -d '"' >> inventory/sanitised_inventory.txt
done < $inventory

# Sanitise check-cards file by removing card count
awk '{$1=""}1' $check_target | awk '{$1=$1}1' > check-cards/sanitised-check-cards.txt

# Read the content of the sanitised check-cards into an array
# Discard first 2 lines, strip newlines
# mapfile -t inventory_items < inventory/sanitised_inventory.txt
mapfile -t check_card_items < check-cards/sanitised-check-cards.txt

# # DEBUG - Print the array, format it with a newline after each entry
# printf "%s\n" "${inventory_items[@]}"


# Initialize an associative array to keep track of found items
declare -A found_items

# Read the inventory file line by line
while IFS=, read -r item; do
    # echo $item

    # Check if an item is in the inventory_items array
    for check_card_item in "${check_card_items[@]}"; do
        if [[ "$item" == "$check_card_item" ]]; then
            found_items["$item"]=1
        fi
    done

# done < check-cards/sanitised-check-cards.txt
done < inventory/sanitised_inventory.txt

# Count the number of items in check_card_item
total_check_card_items=${#check_card_items[@]}

# Count the number of found items
total_found_items=${#found_items[@]}

# Print the counts
echo "----------------------------------------------"
echo "Total number of cards in $check_target : $total_check_card_items"
echo "Total matches found: $total_found_items"

# Print the summary of found items
echo "----------------------------------------------"
echo "Summary of found cards:"
for item in "${!found_items[@]}"; do
    echo "$item"
done

# Print the summary of not found items
echo "----------------------------------------------"
echo "Summary of not found cards:"
for check_card_item in "${check_card_items[@]}"; do
    if [[ -z "${found_items[$check_card_item]}" ]]; then
        echo "$check_card_item"
    fi
done

# Save the first item from the check_card_items array, remove special characters and spaces, and add the current date in the report_name variable
sanitised_first_item=$(echo "${check_card_items[0]}" | tr -cd '[:alnum:]')
report_name="${sanitised_first_item}_$(date +%Y-%m-%d)"

# Save everything that has been printed on std out to the reports/$report_name.txt file
{
    echo "----------------------------------------------"
    echo "Total number of cards in $check_target : $total_check_card_items"
    echo "Total matches found: $total_found_items"
    echo "----------------------------------------------"
    echo "Summary of found cards:"
    for item in "${!found_items[@]}"; do
        echo "$item"
    done
    echo "----------------------------------------------"
    echo "Summary of not found cards:"
    for check_card_item in "${check_card_items[@]}"; do
        if [[ -z "${found_items[$check_card_item]}" ]]; then
            echo "$check_card_item"
        fi
    done
} > "reports/$report_name.txt"

# Clean up after ourselves
# Delete sanitised inventory
rm -f inventory/sanitised_inventory.txt

# Delete sanitised check-card file
rm -f check-cards/sanitised-check-cards.txt

exit 0
