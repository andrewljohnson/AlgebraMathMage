# 2s, 3s, 10s, 5s, 0s, 1s, squares

import json
import random

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

def new_problem(problem_id, sectionInteger, multiplier):
    return {
      "id": problem_id,
      "formulaNumbers": [sectionInteger, multiplier],
      "hint": f"This means something like {multiplier} piles of {sectionInteger} cookies.",
      "answer": multiplier * sectionInteger,
      "formulaOperation": "multiplication",
      "formulaOrientation": "vertical",
      "type": "number"
    }

for sectionInteger in [2, 3, 10, 5, 0, 1]: # "squares"
    new_section = {
        "sectionTitle": f'Multiplication by {sectionInteger} (in order)',
        "id": section_id,
        "problemIDs": []
    }
    curriculum["chapters"][0]["sections"].append(new_section)
    for multiplier in [1, 2, 3, 4, 5, 6, 7, 8, 9]:
      problem = new_problem(problem_id, sectionInteger, multiplier)
      new_section["problemIDs"].append(problem_id)
      curriculum["problems"].append(problem)
      problem_id += 1
    section_id += 1
    new_section_random = {
        "sectionTitle": f'Multiplication by {sectionInteger} (random)',
        "id": section_id,
        "problemIDs": []
    }
    curriculum["chapters"][0]["sections"].append(new_section_random)
    new_section_random["problemIDs"] = random.sample(new_section["problemIDs"], len(new_section["problemIDs"]))
    section_id += 1

    if sectionInteger == 2:
      break
    
json_formatted_str = json.dumps(curriculum, indent=2)
print(json_formatted_str)

