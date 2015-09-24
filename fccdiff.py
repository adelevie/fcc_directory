import json

def calc_diff(old_path, new_path):
  """Calculates the difference between two versions of FCC directories.

  Args:
    old_path: str. The path to the old directory JSON file.
    new_path: str. The path to the new directory JSON file.
  Returns:
    tuple. (removed, added, property_changes). Where 'removed' is a set of the
    names of people who were removed, 'added' is a set of the names of people
    who were added, and property_changes is a list of tuples in the following
    format:
      (name, "changed|removed|added", key, old_value, new_value)
  """
  with open(old_path) as old:
    old_data = json.load(old)
  with open(new_path) as new:
    new_data = json.load(new)

  old_by_name = dict((o['name'], o) for o in old_data)
  new_by_name = dict((n['name'], n) for n in new_data)

  old_set = set(old_by_name.keys())
  new_set = set(new_by_name.keys())

  removed = old_set - new_set
  added = new_set - old_set

  property_changes = []
  for o_name in old_set:
    if o_name in new_by_name:
      o = old_by_name[o_name]
      n = new_by_name[o_name]
      matching_keys = n.keys()
      for key, value in o.items():
        if n[key] != o[key]:
          property_changes.append((o_name, 'changed', key, o[key], n[key]))
        if key in matching_keys:
          matching_keys.remove(key)
        else:
          property_changes.append((o_name, 'removed', key, o[key], ''))
      for key in matching_keys:
        property_changes.append((o_name, 'added', key, '', n[key]))

  return removed, added, property_changes

def sentences_from_diff(diff):
  ans = []
  removed, added, property_changes = diff
  for r in removed:
    ans.append('%s was removed.' % r)
  for a in added:
    ans.append('%s was added.' % a)
  for name, action, key, old, new in property_changes:
    ans.append(
      '%s had their \'%s\' changed from %s to %s' % (name, key, old, new))
  return ans

if __name__ == '__main__':
  diff = calc_diff('fcc_directory.old.json', 'fcc_directory.json')
  print repr(diff)
  print '\n'.join(sentences_from_diff(diff))
