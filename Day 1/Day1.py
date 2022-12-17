
totals = []

with open("input.txt") as file:
    total = 0
    for line in file.readlines():
        stripped_line = line.strip()
        
        if stripped_line != "":
            total = total + int(stripped_line)
        else:
            totals.append(total)
            total = 0

sorted_list = sorted(totals, reverse=True)
print(sorted_list[0]) # Top Elf

total = 0
for value in sorted_list[:3]:
    total = total + value
print(total) # Top 3 Elfs