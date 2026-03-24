require 'json'

FILEPATH = "ToDoList.json"

unless File.exist?(FILEPATH)
    File.write(FILEPATH, "[]")
end

def clear_console
    system("cls") || system("clear")
end

def load_tasks
    content = File.read(FILEPATH)
    content.empty? ? [] : JSON.parse(content)
end

def save_tasks(tasks)
    File.write(FILEPATH, JSON.pretty_generate(tasks))
end

def menu
    puts "\n=== To-Do List App ==="
    puts "1. Add a task"
    puts "2. View Tasks"
    puts "3. Complete Task"
    puts "4. Delete Task"
    puts "5. Exit"
    print "Enter your choice: "
    
    gets.chomp
end

def add_task
    print "Enter task title: "
    title = gets.chomp
    
    print "Enter priority (low/medium/high): "
    priority = gets.chomp.downcase
    
    tasks = load_tasks
    new_task = {
        "id" => Time.now.to_i,
        "title" => title,
        "completed" => false,
        "priority" => priority,
        "start_date" => Time.now.strftime("%Y-%m-%d"),
        "completed_date" => ""
    }
    
    tasks << new_task
    save_tasks(tasks)
    puts "Task added successfully!"
end

def view_all_tasks
    tasks = load_tasks
    
    if tasks.empty?
        puts "No tasks found."
        return
    end
    
    puts "\n=== All Tasks ==="
    tasks.each_with_index do |task, index|
        status = task["completed"] ? "[x]" : "[ ]"
        puts "#{index + 1}. #{status} #{task["title"]} (#{task["priority"]})"
    end
end

def view_incomplete_tasks
    tasks = load_tasks.select { |task| !task["completed"] }
    
    if tasks.empty?
        puts "No incomplete tasks."
        return
    end
    
    puts "\n=== Incomplete Tasks ==="
    tasks.each_with_index do |task, index|
        puts "#{index + 1}. [ ] #{task["title"]} (#{task["priority"]})"
    end
end

def view_completed_tasks
    tasks = load_tasks.select { |task| task["completed"] }
    
    if tasks.empty?
        puts "No completed tasks."
        return
    end
    
    puts "\n=== Completed Tasks ==="
    tasks.each_with_index do |task, index|
        puts "#{index + 1}. [x] #{task["title"]} (#{task["priority"]})"
    end
end

def viewtasks
    loop do
        puts "\n=== View Tasks ==="
        puts "1. View all tasks"
        puts "2. View incomplete tasks"
        puts "3. View completed tasks"
        puts "4. Back to menu"
        print "Enter your choice: "
        
        choice = gets.chomp
        
        case choice
        when "1"
            clear_console
            view_all_tasks
        when "2"
            clear_console
            view_incomplete_tasks
        when "3"
            clear_console
            view_completed_tasks
        when "4"
            clear_console
            break
        else
            clear_console
            puts "Invalid choice. Please try again."
        end
    end
end

def complete_task
    tasks = load_tasks
    
    if tasks.empty?
        puts "No tasks to complete."
        return
    end
    
    puts "\n=== Complete Task ==="
    tasks.each_with_index do |task, index|
        status = task["completed"] ? "[x]" : "[ ]"
        puts "#{index + 1}. #{status} #{task["title"]}"
    end
    
    print "\nEnter task number to complete: "
    choice = gets.chomp.to_i
    
    if choice >= 1 && choice <= tasks.length
        tasks[choice - 1]["completed"] = true
        tasks[choice - 1]["completed_date"] = Time.now.strftime("%Y-%m-%d")
        save_tasks(tasks)
        puts "Task marked as completed!"
    else
        puts "Invalid task number."
    end
end

def delete_task
    tasks = load_tasks
    
    if tasks.empty?
        puts "No tasks to delete."
        return
    end
    
    puts "\n=== Delete Task ==="
    tasks.each_with_index do |task, index|
        status = task["completed"] ? "[x]" : "[ ]"
        puts "#{index + 1}. #{status} #{task["title"]}"
    end
    
    print "\nEnter task number to delete: "
    choice = gets.chomp.to_i
    
    if choice >= 1 && choice <= tasks.length
        deleted_task = tasks.delete_at(choice - 1)
        save_tasks(tasks)
        puts "Task '#{deleted_task["title"]}' deleted!"
    else
        puts "Invalid task number."
    end
end

# Main program loop
clear_console
loop do
    choice = menu
    
    case choice
    when "1"
        clear_console
        add_task
    when "2"
        clear_console
        viewtasks
    when "3"
        clear_console
        complete_task
    when "4"
        clear_console
        delete_task
    when "5"
        puts "Goodbye!"
        break
    else
        clear_console
        puts "Invalid choice. Please try again."
    end
end
