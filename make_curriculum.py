# 2s, 3s, 10s, 5s, 0s, 1s, squares

import json


curriculum = {
  "chapters": [
    {
      "id": 0,
      "chapterTitle": "Multiplication Facts",
      "sections": [],
    }
  ],
  "problems": []
}

section_id = 0
problem_id = 0

for section in [2, 3, 10, 5, 0, 1, "squares"]:
    new_section = {
        "sectionTitle": f'Multiplication by {section} (in order)',
        "id": section_id,
        "problemIDs": []
    }
    curriculum["chapters"][0]["sections"].append(new_section)
    for multiplier in [1, 2, 3, 4, 5, 6, 7, 8, 9]:
      problem = {
        "id": problem_id,
        "formulaNumbers": [section, multiplier],
        "hint": f"This means something like {multiplier} piles of {section} cookies.",
        "answer": multiplier * section,
        "formulaOperation": "multiplication",
        "formulaOrientation": "vertical",
        "type": "number"
      }
      new_section["problemIDs"].append(problem_id)
      curriculum["problems"].append(problem)
      problem_id += 1
    section_id += 1
    break
    
json_formatted_str = json.dumps(curriculum, indent=2)
print(json_formatted_str)

