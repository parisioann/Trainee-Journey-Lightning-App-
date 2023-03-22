# App Description

This Lightning app allows to create "Journeys" for trainees, which are tasks that need to be completed when joining a team. The Template object provides those tasks. Each Template record has a list of tasks relevant to the specific team function. From inside a template record we can create a new Journey which will automatically insert those tasks into the Journey. The below images show some of the custom logic/UI code that I have implemented: 


- Tasks Progress lwc designed&implemented from scratch: 
1) Green -> Completed
2) Yellow -> In Progress
3) Red - Overdue 
4) Bar to show the completion percentage
![Tasks Progress lwc](https://user-images.githubusercontent.com/97835800/150794682-d5d9eadd-0c2d-40da-a4bd-e480177c41e7.png)

- Create New Journey from inside a Template (custom quick action component and inserted into the record page as a button)
![create journey from template component](https://user-images.githubusercontent.com/97835800/150794690-6abca01d-abd2-4731-8304-5b11b727f845.png)

- A) Edit Tasks prior to saving component(left): It gets the tasks from the newly created  Journey and allows to edit them. B) Mass update tasks by the same amount of days component(right): Increments the completion date for all tasks by the same amount.
![edit tasks upon saving](https://user-images.githubusercontent.com/97835800/150794697-074493fb-5a36-49d1-9280-028d25fae4d7.png)
