#ifndef _CONFIG_H_
#define _CONFIG_H_

#if __cplusplus

/* Where to find <hash_set> or <unordered_set>, if available. */
#define HAVE_HASH_SET 0
#define HASH_SET_H <unordered_set>
#define HASH_SET_CLASS unordered_set
#define HASH_SET_NAMESPACE std

/* Where to find <hash_multiset> or <unordered_multiset>, if available. */
#define HAVE_HASH_MULTISET 0
#define HASH_MULTISET_H <unordered_set>
#define HASH_MULTISET_CLASS unordered_multiset
#define HASH_MULTISET_NAMESPACE std

/* Where to find <hash_map> or <unordered_map>, if available. */
#define HAVE_HASH_MAP 0
#define HASH_MAP_H <unordered_map>
#define HASH_MAP_CLASS unordered_map
#define HASH_MAP_NAMESPACE std

#endif

#endif
