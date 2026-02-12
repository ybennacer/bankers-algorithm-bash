#!/bin/bash
# Banker's Algorithm


# User input for number of processes and resources
read -p "Enter number of processes: " processes
read -p "Enter number of resources: " resources

# Input available resources
echo "Enter available resources: "
read -a available

# Input maximum matrix
echo "Enter maximum matrix: "
max=()
for ((i=0; i<processes; i++)); do
    read -a row
    max[i]="${row[@]}"
done

# Input allocation matrix
echo "Enter allocation matrix: "
allocation=()
for ((i=0; i<processes; i++)); do
    read -a row
    allocation[i]="${row[@]}"
done

# Calculate need matrix
declare -a need
for ((i=0; i<processes; i++)); do
    max_row=(${max[i]})
    alloc_row=(${allocation[i]})
    need_row=()
    for ((j=0; j<resources; j++)); do
        need_row+=($((${max_row[j]} - ${alloc_row[j]})))
    done
    need[i]="${need_row[@]}"
done

# Display need matrix
echo "Need Matrix:"
for ((i=0; i<processes; i++)); do
    echo "P$i: ${need[i]}"
done

# Find safe sequence
safe_sequence=()
declare -a finished
for ((i=0; i<processes; i++)); do
    finished[i]=0
done

work=(${available[@]})

echo -e "\nChecking for a safe sequence..."
while ((${#safe_sequence[@]} < processes)); do
    found=0
    for ((i=0; i<processes; i++)); do
        if [[ ${finished[i]} -eq 0 ]]; then
            need_row=(${need[i]})
            alloc_row=(${allocation[i]})
            can_run=1
            for ((j=0; j<resources; j++)); do
                if [[ ${need_row[j]} -gt ${work[j]} ]]; then
                    can_run=0
                    break
                fi
            done
            if [[ $can_run -eq 1 ]]; then
                safe_sequence+=("P$i")
                finished[i]=1
                found=1
                for ((j=0; j<resources; j++)); do
                    work[j]=$((${work[j]} + ${alloc_row[j]}))
                done
            fi
        fi
    done
    if [[ $found -eq 0 ]]; then
        echo "System is in an unsafe state - no safe sequence exists."
        exit 1
    fi
done

echo "System is in a safe state."
echo "Safe Sequence: ${safe_sequence[@]}"

# Function to check new resource request
function check_request() {
    local p_id=$1
    shift
    local request=($@)
    echo -e "\nProcess P$p_id is requesting resources: ${request[@]}"

    need_row=(${need[p_id]})
    alloc_row=(${allocation[p_id]})

    # Check if request is within Need
    for ((j=0; j<resources; j++)); do
        if [[ ${request[j]} -gt ${need_row[j]} ]]; then
            echo "Request exceeds maximum need! Denied."
            return 1
        fi
    done

    # Check if request can be fulfilled with available resources
    for ((j=0; j<resources; j++)); do
        if [[ ${request[j]} -gt ${available[j]} ]]; then
            echo "Not enough resources available! Denied."
            return 1
        fi
    done

    # Temporarily allocate resources
    for ((j=0; j<resources; j++)); do
        available[j]=$((${available[j]} - ${request[j]}))
        alloc_row[j]=$((${alloc_row[j]} + ${request[j]}))
        need_row[j]=$((${need_row[j]} - ${request[j]}))
    done
   
    allocation[p_id]="${alloc_row[@]}"
    need[p_id]="${need_row[@]}"
    echo "Request granted. System remains in a safe state."
}

# Example Request
read -p "Enter process ID requesting resources: " p_id
read -p "Enter requested resources (space-separated): " -a request
check_request $p_id ${request[@]}