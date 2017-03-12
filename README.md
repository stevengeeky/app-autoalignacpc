# sca-service-autoalignacpc
Align brains to the AC-PC plane by guessing their location given MNI coordinates

## Sample Config

```json
{ 
    "t1": "/N/u/hayashis/Karst/testdata/sca-service-autoalignacpc/t1.nii.gz",
    "coords": [[0,0,0], [0, -16, 0], [0, -8, 40]]
}
```

Output to `./t1_acpc_aligned.nii.gz`
